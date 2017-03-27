$(document).ready ->
  util = require '../injectCommon/util.coffee'
  util.initGetDomPathPlugin()
  addVC= require './addVueClass.coffee'
  addVC.addvueclass.action()
  window.injectVM = require './injectVue.coffee'
