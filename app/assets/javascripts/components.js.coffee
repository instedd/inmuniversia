jQuery.fn.setupComponents = () ->
  for fun in jQuery.componentsSetup
    fun.call(@)

jQuery.registerComponentsSetup () ->
  $('input.ux-datepicker-past', @).datepicker(language: 'es', format: 'dd/mm/yyyy', autoclose: true, endDate: new Date())
  $('a.ux-datepicker-past', @).datepicker(language: 'es', format: 'dd/mm/yyyy', endDate: new Date())
  $('.switch').not('.has-switch')['bootstrapSwitch']()

$ ->
  $(document).setupComponents()
