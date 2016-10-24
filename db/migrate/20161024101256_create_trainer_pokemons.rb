class CreateTrainerPokemons < ActiveRecord::Migration[5.0]
  def change
    create_table :trainer_pokemons do |t|
    	t.references :trainer, foreign_key: true
    	t.references :pokemon, foreign_key: true

      t.timestamps
    end
  end
end
