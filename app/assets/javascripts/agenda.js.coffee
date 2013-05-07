# Update vaccination status on dropdown click
$('body.dashboard #agenda').on 'click', '.vaccination-status .dropdown-menu li a', (evt) ->
  evt.preventDefault()
  
  entry = $(@).closest('.agenda-entry')
  dropdown = $(@).closest('.vaccination-status').loading(true, 2000)
  
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
$('body.dashboard #agenda').on 'changeDate', 'a.ux-datepicker', (evt) ->
  $(@).datepicker('hide')
  $(@).loading(true, 2000)
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