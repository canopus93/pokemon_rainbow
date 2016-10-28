class CreatePokemonBattles < ActiveRecord::Migration[5.0]
  def change
    create_table :pokemon_battles do |t|
    	# t.references :pokemon, foreign_key: true
    	# t.references :pokemon, foreign_key: true
    	t.integer :pokemon1_id, null: false
    	t.integer :pokemon2_id, null: false
    	t.integer :current_turn
    	t.string :state, limit: 45
    	t.integer :pokemon_winner_id
    	t.integer :pokemon_loser_id
    	t.integer :experience_gain
    	t.integer :pokemon1_max_health_point
    	t.integer :pokemon2_max_health_point
        t.string :battle_type, limit: 45

      t.timestamps
    end
  end
end
