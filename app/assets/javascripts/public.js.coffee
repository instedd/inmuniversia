# Scroll for vaccine and disease page, ensures that top affix does not overlap the content when link is clicked
$('#sections-bar').on 'click', 'a', (evt) ->
  evt.preventDefault()
  offset = if $('.static-bar.affix').length == 0 then -110 else -90
  $($(this).attr('href'))[0].scrollIntoView()
  scrollBy(0, offset)