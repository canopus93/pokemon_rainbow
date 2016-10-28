class CreatePokemonBattleLogs < ActiveRecord::Migration[5.0]
  def change
    create_table :pokemon_battle_logs do |t|
    	t.references :pokemon_battle, foreign_key: true
    	t.integer :turn
    	t.string :skill_name, limit: 45
    	t.integer :damage
    	t.integer :attacker_id, null: false
    	t.integer :attacker_current_health_point
    	t.integer :defender_id, null: false
    	t.integer :defender_current_health_point
    	t.string :action_type, limit: 45

      t.timestamps
    end
  end
end
