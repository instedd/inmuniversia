$('#channels').on 'ajax:success', 'form', (event,data)->
  $(this).closest('.channel').html(data)