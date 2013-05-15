$ ->
  window.setTimeout (() -> $(".flash-alert.alert-info").alert('close')),  5000
  window.setTimeout (() -> $(".flash-alert.alert-error").alert('close')), 10000

$.extend
  alert:  (msg, cls='',timeout=null) ->
    alert = $(HandlebarsTemplates['shared/alert']({text: msg, class: cls}))
    $('#alerts').append(alert)
    window.setTimeout((() -> alert.alert('close')), timeout) if timeout? && timeout > 0

  notice: (msg, timeout=5000) ->
    @alert msg, 'alert-info', timeout

  error: (msg, timeout=10000) ->
    @alert msg, 'alert-error', timeout
