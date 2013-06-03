# Toggle new child form
$('#add-new-child').on 'click', 'a', ->
  $('#add-new-child').hide()
  $('#new-child-form').collapse('show')

$('#cancel-add-new-child').on 'click', ->
  $('#new-child-form').collapse('hide')
  $('#add-new-child').show()

$('.checkbox-submit').on 'change', ->
  $(this).closest('form').submit()
  updateCheckboxText(this)

updateCheckboxText = (checkbox) ->
  if $(checkbox).is(':checked')
    $(checkbox).parent().parent().siblings('p').text("Notificaciones activadas")
  else
    $(checkbox).parent().parent().siblings('p').text("Notificaciones desactivadas")

$ ->
  $('.checkbox-submit').each (index, element) =>
    updateCheckboxText(element)

# Update user preference on current active tab when the user switches tabs
$('.dashboard-tabs button').on 'shown', (evt) ->
  updatePreferences('dashboard.active_tab': $(@).data('tab-name'))