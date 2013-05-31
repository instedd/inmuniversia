# Toggle new child form
$('#add-new-child').on 'click', 'a', ->
  $('#add-new-child').hide()
  $('#new-child-form').collapse('show')

$('#cancel-add-new-child').on 'click', ->
  $('#new-child-form').collapse('hide')
  $('#add-new-child').show()

$('.checkbox-submit').on 'change', ->
  $(this).closest('form').submit()
  updateCheckboxText()

updateCheckboxText = ->
  if $('.checkbox-submit').is(':checked')
    $('.checkbox-text').text("Notificaciones activadas")
  else
    $('.checkbox-text').text("Notificaciones desactivadas")

$ ->
  updateCheckboxText()

# Update user preference on current active tab when the user switches tabs
$('.dashboard-tabs button').on 'shown', (evt) ->
  updatePreferences('dashboard.active_tab': $(@).data('tab-name'))