$('#add-new-child').on 'click', 'a', ->
  $('#add-new-child').hide()
  $('#new-child-form').collapse('show')

$('#cancel-add-new-child').on 'click', ->
  $('#new-child-form').collapse('hide')  
  $('#add-new-child').show()