
###*
xxx
###


class DeleteUpdate
  constructor:  ->

  

  _bindEvents: ->
    self = @
    _events =
      deleteText: (e, dompath) ->
        $(dompath).attr('value','')
        $(dompath).removeAttr('timbr_attr')
        return
    $('body').on _events





module.exports = 
  deleteupdate: new DeleteUpdate
