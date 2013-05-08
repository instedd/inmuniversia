@gon ||= {}

jQuery.extend(window, Routes)

jQuery.registerComponentsSetup = (callback) ->
  jQuery.componentsSetup ||= []
  jQuery.componentsSetup.push(callback)
