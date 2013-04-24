jQuery.fn.setupComponents = () ->
  $('.datepicker', this).datepicker(language: 'es', format: 'dd/mm/yyyy')

$ ->
  $(document).setupComponents()