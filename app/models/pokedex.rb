class Pokedex < ApplicationRecord
	has_many :pokemon, dependent: :destroy
	
	extend Enumerize

	ELEMENT_TYPE_LIST = [:normal, :fighting, :flying, :poison, :ground, :rock, :bug, :ghost, :steel, :fire, :water, :grass, :electric, :psychic, :ice, :dragon, :dark, :fairy]

	enumerize :element_type, in: ELEMENT_TYPE_LIST

	validates :name, presence: true, uniqueness: true,
					 								length: { maximum: 45 }
	validates :base_health_point, presence: true,
													numericality: { greater_than: 0 }
	validates :base_attack, presence: true,
													numericality: { greater_than: 0 }
	validates :base_defence, presence: true,
													numericality: { greater_than: 0 }
	validates :base_speed, presence: true,
													numericality: { greater_than: 0 }
	validates :element_type, presence: true,
					 								length: { maximum: 45 }
end
