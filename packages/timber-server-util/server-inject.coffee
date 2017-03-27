URL = Npm.require 'url'

class @InjectJs
  constructor: (type, url, content, @removeScript) ->
    @possibleTypes = ['injectSearch', 'injectSampling', 'injectResult']
    if type in @possibleTypes
      @type = type
    else
      @type = null
    @url = url
    @srcdoc = content
  getInjectJsPath: -> Meteor.absoluteUrl "js/inject/#{@type}/build.js"
  getInjectCssPath: -> Meteor.absoluteUrl "js/inject/#{@type}/build.css"
  preProcess: ($) ->
    self = @
    if @removeScript is 'removeScript'
      $('script').remove()
      $('iframe').remove()

    isRel = (src) ->
      return src? and src.indexOf('http') isnt 0 and src.indexOf('//') isnt 0

    $('link[rel="stylesheet"]').not('.inject-css').each ->
      href = $(this).attr('href')
      if isRel href
        $(this).attr('href', URL.resolve(self.url, href))
    $('*[src]').each ->
      src = $(this).attr('src')
      if isRel src
        $(this).attr('src', URL.resolve(self.url, src))
    $('*[href]').each ->
      href = $(this).attr('href')
      if isRel href
        $(this).attr('href', URL.resolve(self.url, href))
    return $
  postProcess: ($) ->
    $('head').append "<link class='inject-css' rel='stylesheet' href='#{@getInjectCssPath()}'>"
    if @type is 'injectSearch'
      $('head').prepend "<script src='https://cdnjs.cloudflare.com/ajax/libs/vue/0.11.4/vue.min.js'></script>"
    $('body').append "<script src='//code.jquery.com/jquery-1.11.1.min.js' data-from='timber'></script>"
    $('body').append "<script src='#{@getInjectJsPath()}' data-from='timber'></script>"
    $('body').attr 'timber-url', @url
    # $("input[name='query']").css('z-index', '9999')    This is for walmart 
    # if $("script[src*='/__ssobj/ard.png']")
    #   console.log "found script"
    #   $("script[src*='/__ssobj/ard.png']").remove()
    return $

  inject: ->
    self = @
    $ = cheerio.load @srcdoc
    $ = @preProcess $
    $ = @postProcess $
    return $.html()
