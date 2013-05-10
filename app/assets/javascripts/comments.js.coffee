jQuery ->
  # Create a comment
  $(".comment-form")
    .on "ajax:beforeSend", (evt, xhr, settings) ->
      $(this).find('textarea')
        .addClass('uneditable-input')
        .attr('disabled', 'disabled');
    .on "ajax:success", (evt, data, status, xhr) ->
      $(this).find('textarea')
        .removeClass('uneditable-input')
        .removeAttr('disabled', 'disabled')
        .val('');
      $(xhr.responseText).hide().insertBefore($(this)).show('slow')
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
      $(content).insertAfter($("#comment-#{comment_id}"))
    error: =>
  false