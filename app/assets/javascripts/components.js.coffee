jQuery.fn.setupComponents = () ->
  for fun in jQuery.componentsSetup
    fun.call(@)

jQuery.registerComponentsSetup () ->
  $('input.ux-datepicker', @).datepicker(language: 'es', format: 'dd/mm/yyyy')
  $('a.ux-datepicker', @).datepicker(language: 'es', format: 'dd/mm/yyyy')
  
$ ->
  $(document).setupComponents()


