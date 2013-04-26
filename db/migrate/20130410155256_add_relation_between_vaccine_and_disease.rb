class AddRelationBetweenVaccineAndDisease < ActiveRecord::Migration
  def up
    create_table :diseases_vaccines, :id => false do |t|
      t.references :disease, :vaccine
    end

    add_index :diseases_vaccines, [:disease_id, :vaccine_id], name: "index_diseases_vaccines"
  end

  def down
    drop_table :diseases_vaccines
  end
end
