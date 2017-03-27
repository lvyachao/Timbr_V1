Task = new Mongo.Collection 'task'
TaskTable = new Mongo.Collection 'task-table'
TaskMessage = new Mongo.Collection 'task-message'

Meteor.publish 'taskRealtime', (taskId) ->
  check taskId, String
  return [
    Task.find {taskId:taskId}
    TaskTable.find {taskId:taskId}
    TaskMessage.find {taskId:taskId}
  ]

class TimberQueue
  constructor: (mode) ->
    @queue = new PowerQueue
      maxProcessing: 1
      onEnded: ->
        console.log 'ended!'
  run: (json) =>
    Task.insert json
    if json.nextPage.nextButtonMode is 'button'
      return @_runNextButton json
    else if json.nextPage.nextButtonMode is 'links'
      return @_runNextLinks json

  _runNextButton: (json) ->
    pageCount = json.nextPage.pageCount
    remainCount = pageCount

    _crawlPage = (taskJson) ->
      tuples = taskJson.tuples
      attributes = taskJson.attributes
      nextPage = taskJson.nextPage
      $tuples = document.querySelectorAll tuples
      resJson =
        meta: taskJson
        table: []
      Array.prototype.forEach.call $tuples, (el) ->
        entry = {}
        entry.taskId = taskJson.taskId
        attributes.forEach (attr) ->
          attrContent = el.querySelectorAll(attr.selector)
          if attrContent.length >= 1
            entry[attr.name] = attrContent[0].textContent.trim()
          else
            entry[attr.name] = ''
        resJson.table.push entry
      return resJson

    _crawlPageResult = Meteor.bindEnvironment (resJson) ->
      remainCount--
      Task.update {taskId: resJson.meta.taskId}, {
        $set: {progress: (pageCount - remainCount) / pageCount}
      }
      _.each resJson.table, (entry) ->
        TaskTable.insert entry
      return null

    res = Async.runSync (done) ->
      nm = new TimberServerUtil.Nightmare()
        .useragent TimberServerUtil.userAgent
        .goto json.url
      for _ in [0...pageCount]
        nm = nm
          .wait json.ajaxTimeout
          .evaluate _crawlPage, _crawlPageResult, json
          .click json.nextPage.selectorNext
      nm.run(done)
    return null

  _runNextLinks: (json) ->

    pageCount = json.nextPage.pageCount
    remainCount = pageCount

    linksList = [{name: '1', href: json.url}]
    seen = {}
    visited = {}
    VISITED = 1

    _crawlPage = (taskJson) ->
      tuples = taskJson.tuples
      attributes = taskJson.attributes
      nextPage = taskJson.nextPage
      $tuples = document.querySelectorAll tuples
      $links = document.querySelectorAll nextPage.selectorNext
      resJson =
        table: []
        links: []
      Array.prototype.forEach.call $tuples, (el) ->
        entry = {}
        entry.taskId = taskJson.taskId
        entry.from = taskJson.from
        attributes.forEach (attr) ->
          attrContent = el.querySelectorAll(attr.selector)
          if attrContent.length >= 1
            entry[attr.name] = attrContent[0].textContent.trim()
          else
            entry[attr.name] = ''
        resJson.table.push entry

      Array.prototype.forEach.call $links, (el) ->
        entry = {}
        entry.name = el.textContent
        if el.href?
          entry.href = el.href
        else if el.querySelector('a')
          entry.href = el.querySelector('a').href
        else
          entry.href = ''
        resJson.links.push entry
      return resJson

    _crawlPageResult = Meteor.bindEnvironment (done, resJson) ->

      hashAttrs = (obj) ->
        keys = []
        if obj
          for key of obj
            keys.push key
        keys.sort()
        tObj = {}
        for index of keys
          key = keys[index]
          tObj[key] = obj[key]
        s = JSON.stringify tObj
        s = s.split('').reduce ((a, b) ->
          a = (a << 5) - a + b.charCodeAt(0)
          a & a
        ), 0
        return s.toString()

      prior = (list, el) ->
        l = list.length
        list = _.reject list, (item) ->
          item.href is el.href
        if l > list.length
          list.push el
        return list

      if resJson.table.length
        nodeId = hashAttrs _.omit(resJson.table[0], ['from', 'nodeId', 'links'])
        resJson.table[0].nodeId = nodeId
        resJson.table[0].links = resJson.links
        TaskTable.insert resJson.table[0]
      remainCount--
      _.each resJson.links, (link) ->
        if not _.has seen, link.href
          seen[link.href] = VISITED
          link.from = resJson.table[0].nodeId
          linksList.push link

      #_.each resJson.links, (link) ->
        #if _.has seen, link.href
          #linksList = prior(linksList, link)
      #_.each resJson.links, (link) ->
        #if _.has visited, link.href
          #linksList = prior(linksList, link)

      TaskMessage.insert
        taskId: json.taskId
        message:
          remainCount: remainCount
          queueLength: linksList.length
          queue: linksList
      done()
      return null

    while remainCount >0 and linksList.length > 0
      Async.runSync (done) ->
        #link = linksList.shift()
        link = linksList.pop()
        visited[link.href] = VISITED
        if link.href isnt ''
          TaskMessage.insert
            taskId: json.taskId
            message:
              href: link.href
          nm = new TimberServerUtil.Nightmare()
            .useragent TimberServerUtil.userAgent
            .goto link.href
            .wait json.ajaxTimeout
            .evaluate _crawlPage, _.partial(_crawlPageResult, done), _.extend(json, {from: link.from})
            .run()
    return null

@TimberQueue = TimberQueue
