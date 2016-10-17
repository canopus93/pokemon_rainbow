class Pokedex < ApplicationRecord
	has_many :pokemon, dependent: :destroy

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
