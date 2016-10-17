class CreatePokedexes < ActiveRecord::Migration[5.0]
  def change
    create_table :pokedexes do |t|
    	t.string :name,	limit: 45
    	t.integer :base_health_point
    	t.integer :base_attack
    	t.integer :base_defence
    	t.integer :base_speed
    	t.string :element_type, limit: 45
    	t.string :image_url

      t.timestamps
    end
  end
end
