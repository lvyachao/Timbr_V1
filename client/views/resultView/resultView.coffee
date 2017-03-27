@Task = new Mongo.Collection 'task'
@TaskTable = new Mongo.Collection 'task-table'
@TaskMessage = new Mongo.Collection 'task-message'

String::trunc = String::truc or (n, useWordBoundary) ->
  toLong = @length > n
  s_ = if toLong then @substr(0, n - 1) else this
  s_ = if useWordBoundary and toLong then s_.substr(0, s_.lastIndexOf(' ')) else s_
  if toLong then s_ + '...' else s_

Template.resultView.rendered = ->
  window.resultVM = new Vue
    el: '.t-Result'
    ready: ->
      self = @
      renderjson.set_show_to_level(1)
      toastr.options =
        closeButton: true
        positionClass: 'toast-bottom-center'
      $('.t-Result-Panel').mCustomScrollbar
        theme: 'rounded-dark'
        mouseWheel:
          scrollAmount: 150
        scrollButtons:
          enable: false
        advanced:
          updateOnContentResize: true
      NProgress.configure
        parent: '.t-Result-IframeResult-Panel'

      self.states = StateMachine.create
        initial: 'url'
        events: [
          {name: 'nextState', from: 'url', to: 'tuples'},
          {name: 'nextState', from: 'tuples', to: 'attrs'},
          {name: 'nextState', from: 'attrs', to: 'nextpages'},
          {name: 'backState', from: 'tuples', to: 'url'},
          {name: 'backState', from: 'attrs', to: 'tuples'},
          {name: 'backState', from: 'nextpages', to: 'attrs'},
          {name: 'initState', from: '*', to: 'url'}
        ]
        callbacks:
          onurl: ->
            self.showPanels = ['url', 'next']
            self.initTwoClick()
            self.initNextpage()
            self.isOnUrl = true
          ontuples: ->
            self.showPanels = ['tuples', 'next']
            self.enableTuplesMode 'Advanced'
          onattrs: ->
            self.showPanels = ['attrs', 'next']
            if self.selectorAttrs.length is 0
              self.addAttr()
            self.iframeTrigger 'enableAttrHighLight'
          onnextpages: ->
            self.showPanels = ['nextpages', 'submit']
            self.enableNextButtonHighLight 'button'
          onleaveurl: (e, from, to) ->
            if to in ['tuples', 'attrs','nextpages']
              if self.isUrlPanelValid()
                self.isOnUrl = false
                return true
              else
                return false
          onleavetuples: (e, from, to) ->
            if to in ['attrs','nextpages']
              if self.isTuplesPanelValid()
                self.clearHighLight()
                return true
              else
                return false
          onleaveattrs: (e, from, to) ->
            if to in ['nextpages']
              self.isAttrsPanelValid()
    data:
      urlContent: ''
      urlInput: ''
      urlLoaded: ''
      loadingDoc: ''
      ajaxTimeout: 1000
      showPanels: ['url', 'next']
      selectorSimpleStr: ''
      selectorAdvancedStr: ''
      tuplesMode: 'Simple'
      isTuplesSelected: false
      selectorAttrs: []
      selectorAttrsIndex: -1
      nextButtonMode: 'button'
      isNextpageSelected: false
      selectorNext: ''
      pageCount: 0
      isOnUrl: true
      crawlPercent: 0
      logMessages: []
    computed:
      tuples: ->
        if @tuplesMode is 'Simple'
          return @selectorSimpleStr
        else if @tuplesMode is 'Advanced'
          return @selectorAdvancedStr
      nextPage: ->
        nextButtonMode: @nextButtonMode
        selectorNext: @selectorNext
        pageCount: parseInt @pageCount
    methods:
      # Communication
      iframeTrigger: (event, data=null) ->
        $('iframe')[0].contentWindow.$?('body').trigger event, data
      clearHighLight: ->
        @iframeTrigger 'clearHighLight'

      # logMessages
      jsonLogMessages: (json) ->
        str = JSON.stringify json, null, 2
        return "<pre>#{str}</pre>"

      # States Related
      needToShow: (panel) ->
        return _.contains @showPanels, panel
      nextState: ->
        @states.nextState()
      backState: ->
        @states.backState()

      # Url Content Panel
      onClickExampleBtn: (e) ->
        url = $(e.target).data().url
        @urlInput = url
        @getUrlContent()

      setUrlContentFromSearch: (jsonFromSearch) ->
        $('a[href="#t-Result-Tuples-Control-Simple"]').tab 'show'
        @urlContent = jsonFromSearch.urlContent
        @urlLoaded = jsonFromSearch.urlLoaded
        @UrlInput = jsonFromSearch.urlLoaded

      getUrlContent: ->
        url = @urlInput
        NProgress.start()
        @states.initState()
        $('a[href="#t-Result-Tuples-Control-Simple"]').tab 'show'
        Meteor.call 'getPhContent', url, 'injectResult', 'removeScript', (error, result) =>
          @urlContent = result
          @urlLoaded = url
          NProgress.done()

      isUrlPanelValid: ->
        if @urlLoaded is ''
          toastr.error 'Please load a URL first.'
          return false
        else
          return true

      # Tuples Panel
      enableTuplesMode: (mode) ->
        @tuplesMode = mode
        if mode is 'Simple'
          @iframeTrigger 'enableOneClickHighLight'
        if mode is 'Advanced'
          @iframeTrigger 'enableTwoClickHighLight'
      initTwoClick: ->
        @iframeTrigger 'clearHighLight'
        @selectorAdvancedStr = ''
        @isTuplesSelected = false
        @selectorAttrs = []
        $('a[href="#t-Result-Iframe-Tab"]').tab 'show'
      refreshTwoClick: ->
        @initTwoClick()
        @iframeTrigger 'enableTwoClickHighLight'
      isTuplesPanelValid: ->
        if @tuples is ''
          toastr.error 'Whoops, please choose some tuples.'
          return false
        else
          return true

      # Attr Panel
      addAttr: ->
        if @isTuplesSelected
          @selectorAttrs.push
            name: ''
            selector: ''
          @addAttrSelector()
        else
          toastr.error 'Please select tuples first'
        $('a[href="#t-Result-Iframe-Tab"]').tab 'show'
      addAttrSelector: (index = @selectorAttrs.length - 1) ->
        @selectorAttrsIndex = index
        @iframeTrigger 'enableAttrHighLight'
      rmAttr: (index) ->
        @selectorAttrs.splice index, 1
      setAttr: (val) ->
        if @selectorAttrsIndex isnt -1
          @selectorAttrs[@selectorAttrsIndex].selector = val
      isAttrsPanelValid: ->
        if @selectorAttrs.length is 0
          toastr.error 'Please add some attributes.'
          return false
        nullExist = _.some @selectorAttrs, (item) ->
          item.name is '' or item.selector is ''
        if nullExist
          toastr.error 'Please complete the attributes.'
          return false
        nameList = _.map @selectorAttrs, (item) -> item.name
        duplicateExist = _.uniq(nameList).length isnt nameList.length
        if duplicateExist
          toastr.error 'Please do not use the same attribute name.'
          return false
        return true

      # Next Page
      enableNextButtonHighLight: (mode) ->
        @nextButtonMode = mode
        @isNextpageSelected = true
        @iframeTrigger 'enableNextButtonHighLight', @nextButtonMode
      initNextpage: ->
        @isNextpageSelected = false
        @iframeTrigger 'clearHighLight'
        @selectorNext = ''
        $('a[href="#t-Result-Iframe-Tab"]').tab 'show'
      refreshNextpage: ->
        @initNextpage()
        @iframeTrigger 'enableNextButtonHighLight', @nextButtonMode
      isNextPageValid: ->
        p = @nextPage.pageCount
        if p <= 0
          toastr.error 'Please enter valid page count'
          return false
        else if @selectorNext is ''
          toastr.error 'Please select the next page button or next pages in Iframe'
          $('a[href="#t-Result-Iframe-Tab"]').tab 'show'
          return false
        else
          return true

      # Submit Panel
      isPreviewValid: ->
        _.every [
          @isUrlPanelValid()
          @isTuplesPanelValid()
          @isAttrsPanelValid()
        ]

      isCrawlValid: ->
        _.every [
          @isPreviewValid()
          @isNextPageValid()
        ]

      setTableConfig: ->
        columns: _.map @taskJson?.attributes, (item) ->
          data: item.name
          title: item.name
        pageLength: 10
        order: []

      showPreviewTable: ->
        $('a[href="#t-Result-Preview-Table-Tab"]').tab 'show'
        if @previewTable?
          @previewTable.destroy()
          $('.t-Result-Preview-Table').empty()
        @previewTable = $('.t-Result-Preview-Table').DataTable @setTableConfig()
        Meteor.call 'previewResult', @taskJson, (error, data) =>
          @previewTable
            .rows.add data.table
            .columns.adjust()
            .draw()
          console.log data
          console.log @previewTable

      showCrawl: ->
        if @nextButtonMode is 'button'
          @showCrawlTable()
        if @nextButtonMode is 'links'
          @showCrawlGraph()

      showCrawlTable: ->
        $('a[href="#t-Result-Crawl-Table-Tab"]').tab 'show'
        NProgress.start()
        @crawlPercent = 1
        if @crawlTable?
          @crawlTable.destroy()
          $('.t-Result-Crawl-Table').empty()
        @crawlTable = $('.t-Result-Crawl-Table').DataTable @setTableConfig()
        taskOb = Task.find({taskId: @taskJson.taskId}).observeChanges
          changed: (id, fields) =>
            percent = fields.progress
            NProgress.set percent
            @crawlPercent = parseInt 100*percent
        buffer = []
        bufferSize = 10
        taskTableOb = TaskTable.find({taskId: @taskJson.taskId}).observeChanges
          added: (id, fields) =>
            buffer.push fields
            if buffer.length is bufferSize
              @crawlTable
                .rows.add buffer
                .columns.adjust()
                .draw()
              buffer = []
        Meteor.subscribe 'taskRealtime', @taskJson.taskId
        Meteor.call 'runQueue', @taskJson, (error, data) =>
          NProgress.done()
          @crawlTable
            .rows.add buffer
            .columns.adjust()
            .draw()
          taskOb.stop()
          taskTableOb.stop()

      initGraph: ->
        if @visGraph?
          @visGraph.destroy()
        @visNodes = new vis.DataSet()
        @visEdges = new vis.DataSet()
        @visData =
          nodes: @visNodes
          edges: @visEdges
        @visContainer = $('.t-Result-Graph')[0]
        @visOptions =
          nodes: shape: 'box'
        @visGraph = new vis.Network @visContainer, @visData, @visOptions

      showCrawlGraph: ->
        self = @
        labelTruncNum = 30

        $('a[href="#t-Result-Graph-Tab"]').tab 'show'
        self.initGraph()
        self.logMessages = []
        Meteor.subscribe 'taskRealtime', @taskJson.taskId
        taskMessageOb = TaskMessage.find({taskId: @taskJson.taskId}).observeChanges
          added: (id, fields) ->
            self.logMessages.push fields
        taskTableOb = TaskTable.find({taskId: @taskJson.taskId}).observeChanges
          added: (id, fields) ->
            self.logMessages.push fields
            if _.has fields, 'nodeId'
              node =
                id: fields.nodeId
                label: fields[self.selectorAttrs[0].name].trunc labelTruncNum, true
                title: renderjson _.omit(fields, ['from', 'nodeId'])
              try
                self.visNodes.add node
              catch error
                console.log error
            if _.has fields, 'from'
              edge =
                from: fields.from
                to: fields.nodeId
              console.log edge
              self.visEdges.add edge

        NProgress.start()
        Meteor.call 'runQueue', @taskJson, (error, data) =>
          NProgress.done()

      submitResultJson: (@submitMode) ->
        @taskJson =
          tuples: @tuples
          attributes: @selectorAttrs
          url: @urlLoaded
          nextPage: @nextPage
          ajaxTimeout: @ajaxTimeout
          mode: 'bfs'
          taskId: Random.id()
          progress: 0.1
        if @submitMode is 'preview' and @isPreviewValid()
          @showPreviewTable()
        if @submitMode is 'crawl' and @isCrawlValid()
          @showCrawl()
