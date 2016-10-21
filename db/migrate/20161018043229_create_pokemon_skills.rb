class CreatePokemonSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :pokemon_skills do |t|
    	t.references :pokemon, foreign_key: true
    	t.references :skill, foreign_key: true
    	t.integer :current_pp

      t.timestamps
    end
  end
end
