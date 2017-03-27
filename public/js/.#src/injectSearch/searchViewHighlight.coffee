
###*
Add class to injected page for highlights
###

class SearchViewHighlight
  constructor: ->
    @count = 0
    @highlightClass = '__highlight'

  enableclick: ->
    alert "you can click now"
    self = @
    $("body *").click (e) ->
      e.stopPropagation()
      e.preventDefault()
      self.count++
      $(e.target).wrap "<div id='timber__wrapped'></div>"
      # self.highlightClass = '__highlight'+ self.count
      # Count for different color class to be continue
      $("#timber__wrapped").each ->
        $(this).addClass self.highlightClass
        return
    return


searchViewHighlight= new SearchViewHighlight()
module.exports = searchViewHighlight
