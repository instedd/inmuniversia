# Replaces the selected element with a loading indicator
$.fn.loading = (toggle=true, timeout) ->
  if timeout
    handle = window.setTimeout (()=> $(@).loading(toggle)), timeout
    $(@).data('loading-timeout', handle)
    return $(@)

  window.clearTimeout($(@).data('loading-timeout'))
  isLoading = $(@).hasClass('loading-nodisplay')
  
  if isLoading && toggle == false
    $(@).removeClass('loading-nodisplay')
    $(@).next('.loading').remove()
  
  else if !isLoading && toggle == true
    $(@).addClass('loading-nodisplay').after('<span class="loading">Loading...</span>')

  return $(@)
