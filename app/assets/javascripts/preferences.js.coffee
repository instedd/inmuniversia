@.updatePreferences = (prefs) ->
  $.ajax
    type: 'PUT'
    url: '/settings/preferences'
    data: {preferences: prefs}