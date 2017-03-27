class Util
  constructor: ->
    @_absolutePath()
  _absolutePath: ->
    return


  initGetDomPathPlugin: ->

    $?.fn.getIdClassNamePath = ->
      p = []
      el = $(this).first()
      el.parents().not("html").each ->
        p.push getIdClassJsonForElement(this)
        return
      p.reverse()
      p.push getIdClassJsonForElement(el[0])
      return p



  	getIdClassJsonForElement = (el) ->
      json =
        tagName: el.tagName
        id: el.id
        classList: if el.className then el.className.trim().replace(/\s+/g,  ".").split('.') else []




       # classNamePath = self._getClicksPath([$(this), $(this)])

util = new Util
module.exports = util
