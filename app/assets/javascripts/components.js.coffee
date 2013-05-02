jQuery.fn.setupComponents = () ->
  # Datepicker in inputs
  $('input.ux-datepicker', @).datepicker(language: 'es', format: 'dd/mm/yyyy')
  
  # Datepicker in labels
  $('a.ux-datepicker', @).datepicker(language: 'es', format: 'dd/mm/yyyy')


$ ->
  $(document).setupComponents()