jQuery ->
  # Create a comment
  $(".comment-form")
    .on "ajax:beforeSend", (evt, xhr, settings) ->
      $(this).find('textarea')
        .addClass('uneditable-input')
        .attr('disabled', 'disabled')
    .on "ajax:success", (evt, data, status, xhr) ->
      $(this).find('textarea')
        .removeClass('uneditable-input')
        .removeAttr('disabled', 'disabled')
        .val('')
      $(xhr.responseText).hide().insertBefore($(this)).show('slow')
    .on "ajax:error", (evt, data, status, xhr) ->
      $(this).find('textarea')
        .removeClass('uneditable-input')
        .removeAttr('disabled', 'disabled')
        .val('')
  # Delete a comment
  $(document)
    .on "ajax:beforeSend", ".comment", ->
      $(this).fadeTo('fast', 0.5)
    .on "ajax:success", ".comment", ->
      $(this).hide('fast')
    .on "ajax:error", ".comment", ->
      $(this).fadeTo('fast', 1)

window.commentReport = (event, comment_id, commentable_id) ->
  event.preventDefault()
  $.ajax
    url: comments_load_form_path(id: comment_id, commentable_id: commentable_id)
    type: 'PUT'
    dataType: 'html'
    success: (content) =>
      $("#comment-link-#{comment_id}").hide()
      $(content).hide().insertAfter($("#comment-#{comment_id}")).show('slow')
      loadBeforeAndAfterFunctionsFor(comment_id)
    error: =>
  false

window.cancelAddComment = (event, comment_id) ->
  event.preventDefault()
  $("#comment_form_#{comment_id}").remove()
  $("#comment-link-#{comment_id}").show()

window.loadBeforeAndAfterFunctionsFor = (comment_id) ->
  $("#comment_form_#{comment_id}")
    .on "ajax:beforeSend", (evt, xhr, settings) ->
      $(this).find('textarea')
        .addClass('uneditable-input')
        .attr('disabled', 'disabled')
    .on "ajax:success", (evt, data, status, xhr) ->
      $(xhr.responseText).hide().insertAfter($(this)).show('slow')
      $(this).remove()
    .on "ajax:error", (evt, data, status, xhr) ->
      $(this).find('textarea')
        .removeClass('uneditable-input')
        .removeAttr('disabled', 'disabled')
        .val('')