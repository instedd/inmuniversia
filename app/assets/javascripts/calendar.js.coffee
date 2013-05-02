currentPopover = null
registerOpenPopover = (elem)->
  $(currentPopover).popover('destroy') if currentPopover && currentPopover != elem
  currentPopover = elem

$('body.dashboard').popover
  trigger: 'click'
  html: true
  selector: ".calendar-vaccination"
  content: () ->
    registerOpenPopover(@)
    id = "##{$(@).attr('id')}-popover"
    $(id).html()