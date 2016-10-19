class Skill < ApplicationRecord
	has_many :pokemon_skills, dependent: :destroy
	has_many :pokemons, through: :pokemon_skills

	extend Enumerize

	ELEMENT_TYPE_LIST = [:normal, :fighting, :flying, :poison, :ground, :rock, :bug, :ghost, :steel, :fire, :water, :grass, :electric, :psychic, :ice, :dragon, :dark, :fairy]

	enumerize :element_type, in: ELEMENT_TYPE_LIST

	validates :name, presence: true, uniqueness: true,
					 								length: { maximum: 45 }
	validates :power, presence: true,
											numericality: { greater_than: 0 }
	validates :max_pp, presence: true,
											numericality: { greater_than: 0 }
	validates :element_type, presence: true,
					 						length: { maximum: 45 }
end
