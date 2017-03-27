class Result

  constructor: ->

    @isHighLightEnabled = false
    @isOneClickHighLightEnabled = false
    @isTwoClickHighLightEnabled = false
    @isAttrHighLightEnabled = false
    @highlightClass = '__highlight'
    @permHighlightClass = '__perm-highlight'
    @attrHighlightClass = '__attr-highlight'
    @tuples = ''
    @parentOutput = 'selectorSimpleStr'

    @_initGetDomPathPlugin()
    @_bindEvents()

  api:
    enableOneClickHighLight: @enableOneClickHighLight
    enableTwoClickHighLight: @enableTwoClickHighLight
    enableAttrHighLight: @enableAttrHighLight

  _bindEvents: ->
    self = @
    _events =
      clearHighLight: ->
        self._clearHighLight()
      clearOneClick: ->
        self._clearHighLight()
        self.enableOneClickHighLight()
      clearTwoClick: ->
        self._clearHighLight()
        self.enableTwoClickHighLight()
      enableOneClickHighLight: ->
        self.parentOutput = 'selectorSimpleStr'
        self.enableOneClickHighLight()
      enableTwoClickHighLight: ->
        self.parentOutput = 'selectorAdvancedStr'
        self.enableTwoClickHighLight()
      enableAttrHighLight: ->
        self.enableAttrHighLight()
      enableNextButtonHighLight: (e, nextButtonMode) ->
        self._clearHighLight()
        if nextButtonMode is 'button'
          self.parentOutput = 'selectorNext'
          self.enableOneClickHighLight()
        else if nextButtonMode is 'links'
          self.parentOutput = 'selectorNext'
          self.enableTwoClickHighLight
            mustHaveLinks: true
      absolutePath: (e, url) ->
        self.absolutePath url
    $('body').on _events

  _clearHighLight: ->
    $('*')
      .off 'mouseover'
      .off 'mouseout'
      .off 'click'
      .removeClass @highlightClass
      .removeClass @permHighlightClass
      .removeClass @attrHighlightClass

  _setParentOutput: (val) =>
    escapedVal = @_replaceAddClassName val
    parent.window.resultVM?.$set @parentOutput, escapedVal

  _replaceAddClassName: (str) ->
    self = @
    str = str
      .replace('.'+self.highlightClass, '')
      .replace('.'+self.permHighlightClass, '')
      .replace('.'+self.attrHighlightClass, '')
    return str

  _initGetDomPathPlugin: ->
    self = @

    getClassStringForElement = (el) ->
      string = el.tagName.toLowerCase()
      if el.className
        s = el.className.trim().replace(/\s+/g,  ".")
        s = s.split('.')
        if s.length >= 2
          s = s[0..1]
        string += "." + s.join('.')
      string

    $?.fn.getClassNamePath = ->
      p = []
      el = $(this).first()
      el.parents().not("html").each ->
        p.push getClassStringForElement(this)
        return
      p.reverse()
      p.push getClassStringForElement(el[0])
      return p.join(' > ')

    getIdClassJsonForElement = (el) ->
      json =
        tagName: el.tagName
        id: el.id
        classList: if el.className then el.className.trim().replace(/\s+/g,  ".").split('.') else []

    $?.fn.getIdClassNamePath = ->
      p = []
      el = $(this).first()
      el.parents().not("html").each ->
        p.push getIdClassJsonForElement(this)
        return
      p.reverse()
      p.push getIdClassJsonForElement(el[0])
      return p


  enableOneClickHighLight: ->
    self = @
    $('*')
      .off 'mouseover'
      .off 'mouseout'
      .off 'click'
      .removeClass self.permHighlightClass
      .mouseover (e)->
        e.stopPropagation()
        $(this).addClass self.highlightClass
      .mouseout (e)->
        e.stopPropagation()
        $(this).removeClass self.highlightClass
      .click (e) ->
        e.stopPropagation()
        e.preventDefault()
        classNamePath = self._getClicksPath([$(this), $(this)])
        $(classNamePath).addClass self.permHighlightClass
        self._setParentOutput classNamePath
        parent.window.resultVM?.isTuplesSelected = true
        self.tuples = classNamePath
    @isOneClickHighLightEnabled = true

  enableTwoClickHighLight: (options) ->
    self = @
    twoClicks = []
    $('*')
      .off 'mouseover'
      .off 'mouseout'
      .off 'click'
      .removeClass self.permHighlightClass
      .mouseover (e)->
        e.stopPropagation()
        $(e.target).addClass self.highlightClass
      .mouseout (e)->
        e.stopPropagation()
        $(e.target).removeClass self.highlightClass
      .click (e) ->
        $(e.target).addClass self.permHighlightClass
        e.stopPropagation()
        e.preventDefault()
        if twoClicks.length <= 1
          twoClicks.push $(e.target)
        if twoClicks.length is 2
          intersectionPathSelector = self._getClicksPath(twoClicks)
          if options?.mustHaveLinks is true
            intersectionPathSelector = self._shrimPathToHaveLinks(intersectionPathSelector)
          if options?.looseSelector is true
            intersectionPathSelector = self._shrimPathToLength(intersectionPathSelector, options.looseSelectorLen)
          $(intersectionPathSelector).addClass self.permHighlightClass
          self._setParentOutput intersectionPathSelector
          self.tuples = intersectionPathSelector
          parent.window.resultVM?.isTuplesSelected = true
          twoClicks = []
    @isTwoClickHighLightEnabled = true

  _shrimPathToLength: (selector, len) ->
    sArray = selector.split(' > ')
    return sArray.slice(-len).join(' > ')

  _shrimPathToHaveLinks: (selector) ->
    sArray = selector.split(' > ')
    sArray.pop()
    while sArray.length > 0
      s = sArray.join(' > ') + ' a'
      if $(s).length
        return s
      else
        sArray.pop()
    return selector

  _intersectArray: (a, b) ->
    return a.filter (item) ->
      return b.indexOf(item) isnt -1

  _intersectPath: (path1, path2, common) ->
    self = @
    result = []
    pointer = common
    console.log path1
    console.log path2
    for i in [0...(Math.min(path1.length, path2.length))]
      if path1[i].tagName isnt path2[i].tagName
        return result
      json =
        tagName: path1[i].tagName
        id: if path1[i].id isnt path2[i].id then '' else path1[i].id
        classList: self._intersectArray(path1[i].classList, path2[i].classList)
      result.push json
    commonIndex = common.getIdClassNamePath().length - 1
    console.log commonIndex
    console.log result

    for r in result[0..commonIndex] by -1
      if pointer.parent().children(self._json2string(r)).length > 1
        r.tagName = "#{r.tagName}:nth-child(#{pointer.index() + 1})"
      pointer = pointer.parent()
    return result

  _json2string: (json) ->
    s = ""
    s += json.tagName
    if json.id isnt ''
      s += "##{json.id}"
    if json.classList.length isnt 0
      s += ".#{json.classList.join('.')}"
    return @_replaceAddClassName s

  _pathToJQuerySelector: (path) ->
    self = @
    stringArray = []
    for json in path
      stringArray.push self._json2string json
    s = stringArray.join ' > '

  _getClicksPath: (clicks) ->
    self = @
    path1 = clicks[0].getIdClassNamePath()
    path2 = clicks[1].getIdClassNamePath()
    common =  clicks[0].parents().has(clicks[1]).first()
    intersectionPath = self._intersectPath path1, path2, common
    intersectionPathSelector = self._pathToJQuerySelector intersectionPath
    return intersectionPathSelector

  enableAttrHighLight: ->
    self = @
    $(self.tuples).addClass self.permHighlightClass
    $('*')
      .off 'mouseover'
      .off 'mouseout'
      .off 'click'
      .removeClass self.attrHighlightClass
      .mouseover (e)->
        e.stopPropagation()
        classNamePath = $(this).getClassNamePath()
        self.allEls = $(classNamePath).filter (i, el) ->
          if $(self.tuples).has(el).length
            return true
          else
            return false
        self.allEls.addClass self.highlightClass
      .mouseout (e)->
        e.stopPropagation()
        self.allEls?.removeClass self.highlightClass
      .click (e) ->
        e.stopPropagation()
        e.preventDefault()
        if self.tuples and $(self.tuples).has(e.target).length
          classNamePath = $(this).getClassNamePath().split(' > ').slice(self.tuples.split(' > ').length).join(' > ')
          classNamePath = self._replaceAddClassName classNamePath
          classNamePath = "#{classNamePath}:nth-child(#{$(e.target).index() + 1})"
          $("#{self.tuples} > #{classNamePath}").addClass self.attrHighlightClass
          parent.window.resultVM?.setAttr classNamePath
    @isAttrHighLightEnabled = true

module.exports = new Result
