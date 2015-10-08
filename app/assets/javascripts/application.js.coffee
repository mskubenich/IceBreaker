#= require jquery
#= require jquery_ujs
#= require bootstrap
#= require bootstrap-sprockets
#= require angular
#= require angular-rails-templates
#= require angular-ui-router
#= require angular-ng-dialog
#= require angular-input-match
#= require angular-email-available
#= require angular-file-input
#= require angular-redactor.directive
#= require angular-images.directive
#= require angular-image.directive
#= require underscore
#= require highlight.pack
#= require ahjs
#= require i18n
#= require i18n/translations
#= require angular-range-slider
#= require_tree ../../../vendor/assets/javascripts/redactor
#= require twbs-pagination.js
#= require ui-bootstrap-tpls-0.13.0.min
#= require selectize
#= require angular-bootstrap-lightbox
# load angular modules
#= require ./application/application.module.js
#= require_tree ./application/factories
#= require_tree ./application/controllers
#= require_tree ./application/templates
#= require_tree .

window.previewAvatar = (input, selector) ->
  if input.files && input.files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      $(selector).css('background', 'transparent url(' + e.target.result + ')')
    reader.readAsDataURL(input.files[0])

window.previewAvatar2 = (input) ->
  if input.files && input.files[0]
    reader = new FileReader()
    reader.onload = (e) ->
      $(input).parent().find('.avatar-droppable').css('background', 'transparent url(' + e.target.result + ')')
    reader.readAsDataURL(input.files[0])