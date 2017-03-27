Router.configure
  layoutTemplate: 'layout'

# Router.route '/header', ->
#   @layout 'layout'
#   @render 'header', to: 'header'
#   return

Router.map ->
  @route 'home',
    path: '/'
    yieldTemplates:
      'header': {to: 'header'}
  @route 'searchView',
    path: '/searchView'
    yieldTemplates:
      'header': {to: 'header'}
  @route 'resultView',
    path: '/resultView'
    yieldTemplates:
      'header': {to: 'header'}
