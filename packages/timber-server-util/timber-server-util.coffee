class ServerUtil
  constructor: ->
    @UrlContentCache = new Mongo.Collection 'UrlContentCache'
    @userAgent = 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.10 Safari/537.36'
    @viewport = {width: 3200, height: 1800}
    @Nightmare = Npm.require 'nightmare'

  _cheerio_eq_find: ($obj, selector) ->
    regex = /^(.*?)(?:\:eq\((\d+)\))(.*)/
    parts = []
    match = undefined
    while match = selector.match(regex)
      parts.push match[1]
      parts.push parseInt(match[2], 10)
      selector = match[3].trim()
    parts.push selector
    cursor = $obj.find(parts.shift())
    parts.filter((selector) ->
      selector isnt ""
    ).forEach (selector) ->
      cursor = (if typeof selector is "number" then cursor.eq(selector) else cursor.find(selector))
      return
    cursor

  _isContentCacheValid: (contentCache) ->
    ONE_HOUR = 60 * 60 * 1000
    TTL = 4 * ONE_HOUR
    if ((new Date()) - contentCache.created) < TTL
      return true
    else
      return false

  _parseUrl: (url) ->
    url = encodeURI url
    if !url.match /^[a-zA-Z]+:\/\//
      url = 'http://' + url
    return url

  _crawlPurePageContent: ->
    document.documentElement.innerHTML

  getHttpContent: (url, injectType, removeScript) =>
    check url, String
    res = HTTP.get url, {
      headers:
        'user-agent': 'Mozilla/5.0 (Windows NT 6.3; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.10 Safari/537.36'
      timeout: 5000
    }
    content = res.content
    if injectType?
      inj = new InjectJs(injectType, url, content, removeScript)
      return inj.inject()
    else
      return content

  getPhContent: =>
    # url, injectType, removeScript, cb, cbArgs, resultHandler, ajaxTimeout
    url = @_parseUrl arguments[0] or ''
    injectType = arguments[1] or 'injectResult'
    removeScript = arguments[2] or ''
    cb = arguments[3] or @_crawlPurePageContent
    cbArgs = arguments[4] or null
    resultHandler = arguments[5] or (done, result) ->
      done null, result
    ajaxTimeout = arguments[6] or 1000

    content = ''
    contentCache = @UrlContentCache.findOne({url:url})
    # if contentCache? and @_isContentCacheValid(contentCache)
    #   content = contentCache.content
    if false
      
    else
      res = Async.runSync (done) =>
        new @Nightmare(
          loadImages: false
          )
          .useragent @userAgent
          .goto url
          .wait(ajaxTimeout)
          .evaluate cb, _.partial(resultHandler, done), cbArgs
          .run()
      content = res.result
      @UrlContentCache.upsert({url: url}, {$set: {
        url: url
        content: content
        created: new Date()
      }})
    if injectType?
      inj = new InjectJs(injectType, url, content, removeScript)
      return inj.inject()
    else
      return content

  getSearchContent: =>
    # url, clickarray, injectType, removeScript, cb, cbArgs, resultHandler, ajaxTimeout
    url = @_parseUrl arguments[0] or ''
    clickArray= arguments[1]
    injectType = arguments[2] or 'injectSearch'
    removeScript = arguments[3] or ''
    cb = arguments[4] or null
    cbArgs = arguments[5] or null
    resultHandler = arguments[6] or (done, result) ->
      done null, result
    ajaxTimeout = arguments[7] or 1000

    path = process.env.PWD

    _getHtml= ->
      url: window.location.href
      html: document.documentElement.innerHTML

    res = Async.runSync (done) =>
      nm = new @Nightmare(
        loadImages: false
        )
        .useragent @userAgent
        .viewport @viewport.width, @viewport.height
        .goto url
        .wait(ajaxTimeout)
      for key in clickArray
        if key.type is 'text'
          nm = nm
            .type key.dompath, key.value
            .wait(ajaxTimeout)
        else if key.type is 'checkbox'
          nm = nm
            .click key.dompath
            .wait(ajaxTimeout)
        else if key.type is 'select'
          nm = nm
            .select key.dompath, key.selected
            .wait(ajaxTimeout)
        else if key.type is 'radio'
          nm = nm
            .click key.dompath
            .wait(ajaxTimeout)
        else if key.type is 'submit'
          nm = nm
            .screenshot(path+ '/server/sth.png')
            .click key.dompath
            .wait(5000)
      nm = nm.evaluate _getHtml, (json) ->
        inj = new InjectJs('injectSearch', json.url, json.html, '')
        json.html = inj.inject()
        done null, json
      nm = nm.run()
    return res.result

  previewResult: (taskJson) =>
    self = @
    tuples = taskJson.tuples
    attributes = taskJson.attributes
    url = taskJson.url
    nextPage = taskJson.nextPage
    srcdoc = self.getPhContent url
    $ = cheerio.load srcdoc
    $tuples = $(tuples)
    resJson =
      meta: taskJson
      table: []
    $tuples.each (i, el) ->
      tuple = $(this)
      entry = {}
      entry.taskId = taskJson.taskId
      attributes.forEach (attr) ->
        attrContent = $(tuple).find(attr.selector)
        if attrContent.length >= 1
          entry[attr.name] = attrContent.text().trim()
        else
          entry[attr.name] = ''
      resJson.table.push entry
    return resJson

TimberServerUtil = new ServerUtil
@TimberServerUtil = TimberServerUtil
