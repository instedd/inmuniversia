namespace :calendar do

  desc "Loads into database all official calendar information"
  task :load => :environment do

    Vaccine.setup "Sabin (OPV)",
      {name: "Primera dosis", age_value: 2,  age_unit: "month"},
      {name: "Segunda dosis", age_value: 4,  age_unit: "month"},
      {name: "Tercera dosis", age_value: 6,  age_unit: "month"},
      {name: "Cuarta dosis", age_value: 18,  age_unit: "month"},
      {name: "Refuerzo", age_value: 6,  age_unit: "year"}

    Vaccine.setup "Triple Bacteriana (DPT)",
      {name: "Refuerzo", age_value: 6,  age_unit: "year"}

    Vaccine.setup "Triple Viral (SRP)",
      {name: "Primera dosis", age_value: 12,  age_unit: "month"},
      {name: "Segunda dosis", age_value: 6,  age_unit: "year"},
      {name: "Iniciar o completar esquema", age_value: 11,  age_unit: "year"}

    Vaccine.setup "Pentavalente DTP-HB-Hib",
      {name: "Primera dosis", age_value: 2, age_unit: "month"},
      {name: "Segunda dosis", age_value: 4, age_unit: "month"},
      {name: "Tercera dosis", age_value: 6, age_unit: "month"}

    Vaccine.setup "Cuadruple DTP-Hib",
      {name: "Primer refuerzo", age_value: 18, age_unit: "month"}

    Vaccine.setup "Hepatitis A",
      {name: "Unica dosis", age_value: 12, age_unit: "month"}

  end

end