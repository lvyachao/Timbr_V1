injectVM = new Vue
  el: 'body'
  ready: ->
    @checkCurrentTabCount()
    @initaldataArray()
    @addTabClick()
    @clickReaction()
    @$watch 'inputDataArray', (val) ->
      @synchronousDatatoParent val
      return
    , true

  data:
    currentTabCount: 0
    inputCount: 0
    inputDataArray: []

    clickCount: 0

    tempradionamearray: []
  methods:
    checkCurrentTabCount: ->
      @currentTabCount=parent.window.searchVM.tabCount

    # initGetDomPathPlugin: ->
      # getClassStringForElement = (el) ->
      #   string = el.tagName.toLowerCase()
      #   if el.className
      #     s = el.className.trim().replace(/\s+/g,  ".")
      #     s = s.split('.')
      #     if s.length >= 2
      #       s = s[0..1]
      #     string += "." + s.join('.')
      #   if el.getAttribute 'name'
      #     string += "[name='#{el.getAttribute('name')}']"
      #   return string

      # $?.fn.getClassNamePath = ->
      #   p = []
      #   el = $(this).first()
      #   el.parents().not("html").each ->
      #     p.push getClassStringForElement(this)
      #     return
      #   p.reverse()
      #   p.push getClassStringForElement(el[0])
      #   resultStr = p.join(" > ")
      #   return resultStr

    _pathToJQuerySelector: (path) ->
      self = @
      stringArray = []
      for json in path
        stringArray.push self._json2string json
      s = stringArray.join ' > '

    _json2string: (json) ->
      s = ""
      s += json.tagName
      if json.id isnt ''
        s += "##{json.id}"
      if json.classList.length isnt 0
        s += ".#{json.classList.join('.')}"
      return s

    _getClicksPath: (clicks) ->
      self = @
      path1 = clicks[0].getIdClassNamePath()
      path2 = clicks[1].getIdClassNamePath()
      common =  clicks[0].parents().has(clicks[1]).first()
      intersectionPath = self._intersectPath path1, path2, common
      intersectionPathSelector = self._pathToJQuerySelector intersectionPath
      return intersectionPathSelector

    _intersectArray: (a, b) ->
      return a.filter (item) ->
        return b.indexOf(item) isnt -1

    _intersectPath: (path1, path2, common) ->
      self = @
      result = []
      pointer = common
      for i in [0...(Math.min(path1.length, path2.length))]
        if path1[i].tagName isnt path2[i].tagName
          return result
        json =
          tagName: path1[i].tagName
          id: if path1[i].id isnt path2[i].id then '' else path1[i].id
          classList: self._intersectArray(path1[i].classList, path2[i].classList)
        result.push json
      commonIndex = common.getIdClassNamePath().length - 1
      for r in result[0..commonIndex] by -1
        if pointer.parent().children(self._json2string(r)).length > 1
          r.tagName = "#{r.tagName}:nth-child(#{pointer.index() + 1})"
        pointer = pointer.parent()
      return result


    initaldataArray: ->
      self= @
      $("input[type='text']").each ->
        self.inputDataArray[self.inputCount] =
          count: self.inputCount
          type: @type
          name: @name
          dompath: self._getClicksPath([$(this), $(this)])
          value: ""
          timbr_clicked: false
          MulMode: false

        tempindex=$(@).index()+1
        self.inputDataArray[self.inputCount].dompath=self.inputDataArray[self.inputCount].dompath+":nth-child("+tempindex+")"

        self.inputCount++



      $("input[type='checkbox']").each ->
        if self.inputDataArray[self.inputCount]?
          tempchecked=true
        self.inputDataArray[self.inputCount] =
          count: self.inputCount
          type: @type
          name: @name
          dompath: self._getClicksPath([$(this), $(this)])
          value: @value
          label: $("label[for='" + @id + "']").text().trim()
          timbr_clicked: false

        tempindex=$(@).index()+1
        self.inputDataArray[self.inputCount].dompath += ":nth-child("+tempindex+")"

        if tempchecked?
          self.inputDataArray[self.inputCount].checked=true
        self.inputCount++

      $("input[type='radio']").each ->
        unless @name in self.tempradionamearray
          if self.inputDataArray[self.inputCount]?
            temppicked=self.inputDataArray[self.inputCount].picked

          tempvaluelist=[]
          templabellist=[]
          $("input[name=" + @name + "]").each ->
            tempvaluelist.push @value
            templabellist.push $("label[for='" + @id + "']").text().trim()

          templabeltovalue ={}
          _i=0
          while _i < tempvaluelist.length
            templabeltovalue[tempvaluelist[_i]] = templabellist[_i]
            _i++

          self.inputDataArray[self.inputCount] =
            count: self.inputCount
            type: @type
            name: @name
            dompath: self._getClicksPath([$(this), $(this)])
            value: @value
            label: $("label[for='" + @id + "']").text().trim()
            valueandlabel: templabeltovalue
            picked: @value
            timbr_clicked: false

          if temppicked?
            self.inputDataArray[self.inputCount].picked=temppicked

          self.inputCount++
          self.tempradionamearray.push @name
        else

      $("select").each ->
        tempvaluelist=[]
        templabellist=[]
        $(@).find("option").each ->
          tempvaluelist.push $(this).val()
          templabellist.push $(this).html()

        templabeltovalue ={}
        _j=0
        while _j < tempvaluelist.length
          templabeltovalue[tempvaluelist[_j]] = templabellist[_j]
          _j++

        self.inputDataArray[self.inputCount] =
          count: self.inputCount
          type: "select"
          name: @name
          dompath: self._getClicksPath([$(this), $(this)])
          value: @value
          valueandlabel: templabeltovalue
          timbr_clicked: false
          selected: @value

        tempindex=$(@).index()+1
        self.inputDataArray[self.inputCount].dompath=self.inputDataArray[self.inputCount].dompath+":nth-child("+tempindex+")"
        self.inputCount++

    clickReaction: ->
      self=@


      $('body').on {
        mouseenter: ->
          $(this).addClass('dis')
          return
        mouseleave: ->
          $(this).removeClass('dis')
          return

      }, '.timbr_highlight'

      $("input, select")
        .click (e)->
          # $(@).css 'z-index','999999'
          tempcount=$(@).attr('timbr_count')
          if self.inputDataArray[tempcount].timbr_clicked is false
            self.inputDataArray[tempcount].timbr_clicked=true
            self.inputDataArray[tempcount].timbr_clickedcount=self.clickCount
            self.clickCount++
            # tempid=$(@).attr('id')

            # temptop = $(@).offset().top
            # if $('body').offset().top > 0
            #   temptop = temptop - $('body').offset().top

            # templeft = $(@).offset().left
            # if $('body').offset().left > 0
            #   templeft = templeft - $('body').offset().left

            # templeft = templeft - 2
            # temptop = temptop - 2
            # tempwidth = $(@).width() + 4
            # tempheight = $(@).height() + 4
            # self.addHighlightDiv tempcount, temptop, templeft, tempwidth, tempheigh


      $("input[type='radio']")
        .click (e)->
          tempcount=$(@).attr('timbr_count')
          self.inputDataArray[tempcount].dompath= self._getClicksPath([$(this), $(this)])





    addHighlightDiv: (count, top, left, width, height) ->
      tempmath = Math.floor(Math.random() * 12) + 1

    addTabClick: ->
      self=@
      $("input[type='submit'], button, input[type='button'], a[href]")
        .off 'click'
        .off 'submit'
        .off 'onclick'
        .click (e)->
          e.preventDefault()
          e.stopPropagation()
          tempDompath=self._getClicksPath([$(this), $(this)])
          parent.window.searchVM.openNewTabFromChildren(tempDompath, self.clickCount)



    synchronousDatatoParent:(object) ->
      parent.window.searchVM.synchronousDatafromChildren object

module.exports = injectVM
