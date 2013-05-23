# Handle info popover on calendar
currentPopover = null
registerOpenPopover = (elem)->
  $(currentPopover).popover('destroy') if currentPopover && currentPopover != elem
  currentPopover = elem

# Create vaccination options, with a particular status selected
vaccinationOptionsFor = (status) ->
  options = []
  for option in gon.vaccinationOptions
    option = $.extend({}, option)
    option.selected = 'selected' if option.value == status
    options.push(option)
  options

# Attach handlers to calendars div
$('body.dashboard #calendars')

# Register info popover
.popover
  trigger: 'click'
  placement: 'bottom'
  html: true
  selector: ".calendar-vaccination"
  content: () ->
    registerOpenPopover(@)
    context = $(@).data()
    context.options = vaccinationOptionsFor(context.status)
    context.form_action = vaccination_path(context.id)
    window.setTimeout (=> $(@).closest('td').setupComponents())
    HandlebarsTemplates['calendar/popover'](context)

# Close popover on button click
.on 'click', 'button.ux-close-popover', () ->
  $(currentPopover).popover('destroy') if currentPopover

# Toggle edition handle
.on 'show hide', '#popover-edit', (evt) ->
  if evt.target.id == 'popover-edit'
    $('#popover-edit-handle').collapse('toggle')
    $('#calendar_form .vaccination-status-option.selected').trigger('click')

# Change selected option
.on 'click', '#calendar_form .vaccination-status-option', () ->
  $('#calendar_form .vaccination-status-option').removeClass('selected')
  $(@).addClass('selected')

  value = $(@).data('vaccination-status')
  $('#vaccination_status').val(value)
  $('#popover-edit .taken-at').toggle(value == 'taken')
  false

# Update calendar entry on post success
.on 'submit', '#calendar_form', () ->
  $.ajax
    url: $(@).attr('action')
    type: 'PUT'
    dataType: 'html'
    data: $(@).serialize()
    success: (content) =>
      entry = $(@).closest('.calendar-entry')
      $(currentPopover).popover('destroy')
      $(entry).replaceWith(content)
    error: ->
      # TODO: Handle error
  false

# Toggle to calendar edit
.on 'click', '.configure-calendar', () ->
  $(@).closest('.calendar').hide().next('.calendar-edit').show().addClass('openCalendar')
  false

# Toggle to calendar view
.on 'click', '.cancel-configure-calendar', () ->
  $(@).closest('.calendar-edit').hide().prev('.calendar').show().addClass('openCalendar')
  false