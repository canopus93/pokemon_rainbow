class CreatePokedexEvolutions < ActiveRecord::Migration[5.0]
  def change
    create_table :pokedex_evolutions do |t|
    	t.integer :pokedex_from_id, null: false
    	t.integer :pokedex_to_id, null: false
    	t.integer :minimum_level, null: false

      t.timestamps
    end
  end
end
