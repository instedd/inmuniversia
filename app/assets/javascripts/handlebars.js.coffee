# Register handlebars helpers ifTakenStatus, ifAppliedStatus, etc
if gon.vaccinationOptions
  for vaccinationOption in gon.vaccinationOptions
    status = vaccinationOption.value
    do (status) ->
      name = "if#{status.capitalize()}"
      Handlebars.registerHelper name, (options) ->
        if @.status == status
          options.fn(this)