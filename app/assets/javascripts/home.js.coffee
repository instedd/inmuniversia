# Login form handlers
$('#login-form-container').on 'click', '#sign_up_button', () ->
  $('form#new_subscriber').submit()
  false

.on 'click', '#forgot_pass_button', () ->
  $('form#forgot_subscriber_pass').submit()
  false

.on 'click', '#show_forgot_pass', () ->
  $('#forgot-pass-form').collapse('show')
  $('#login-form').collapse('hide')
  false

.on 'click', '#cancel_forgot_pass', () ->
  $('#forgot-pass-form').collapse('hide')
  $('#login-form').collapse('show')
  false
