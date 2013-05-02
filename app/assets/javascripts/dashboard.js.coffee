# Toggle new child form
$('#add-new-child').on 'click', 'a', ->
  $('#add-new-child').hide()
  $('#new-child-form').collapse('show')

$('#cancel-add-new-child').on 'click', ->
  $('#new-child-form').collapse('hide')  
  $('#add-new-child').show()


# Update user preference on current active tab when the user switches tabs
$('.dashboard-tabs button').on 'shown', (evt) ->
  updatePreferences('dashboard.active_tab': $(@).data('tab-name'))


# Update vaccination status on dropdown click
$('body.dashboard').on 'click', '.vaccination-status .dropdown-menu li a', (evt) ->
  evt.preventDefault()
  
  entry = $(@).closest('.agenda-entry')
  dropdown = $(@).closest('.vaccination-status').loading(true, 200)
  
  $.ajax
    url: vaccination_path(id: entry.data('vaccination-id'))
    type: 'PUT'
    dataType: 'html'
    data: 
      vaccination: { status: $(@).data('vaccination-status') } 
      render: 'agenda'
      date_format: entry.data('date-format')
    success: (content) =>
      entry.html(content).setupComponents()
    error: =>
      dropdown.loading(false)


# Handle date picker date change in agenda
$('body.dashboard').on 'changeDate', 'a.ux-datepicker', (evt) ->
  $(@).datepicker('hide')
  $(@).loading(true, 200)
  entry = $(@).closest('.agenda-entry')
  
  $.ajax
    url: vaccination_path(id: entry.data('vaccination-id'))
    type: 'PUT'
    dataType: 'html'
    data: 
      vaccination: { taken_at: evt.date } 
      render: 'agenda'
      date_format: entry.data('date-format')
    success: (content) =>
      entry.html(content).setupComponents()
    error: =>
      $(@).loading(false)