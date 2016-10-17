class CreateSkills < ActiveRecord::Migration[5.0]
  def change
    create_table :skills do |t|
    	t.string :name, limit: 45
    	t.integer :power
    	t.integer :max_pp
    	t.string :element_type, limit: 45

      t.timestamps
    end
  end
end
