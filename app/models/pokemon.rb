class Pokemon < ApplicationRecord
	belongs_to :pokedex
	has_many :pokemon_battle_pokemon1, class_name: 'PokemonBattle', foreign_key: 'pokemon1_id', dependent: :destroy
	has_many :pokemon_battle_pokemon2, class_name: 'PokemonBattle', foreign_key: 'pokemon2_id', dependent: :destroy
	has_many :pokemon_battle_pokemon_winner, class_name: 'PokemonBattle', foreign_key: 'pokemon_winner_id', dependent: :destroy
	has_many :pokemon_battle_pokemon_loser, class_name: 'PokemonBattle', foreign_key: 'pokemon_loser_id', dependent: :destroy
	has_many :pokemon_skills, dependent: :destroy
	has_many :skills, through: :pokemon_skills
	has_one :trainer_pokemon, dependent: :destroy
	has_one :trainer, through: :trainer_pokemon

	validates :pokedex_id, presence: true
	validates :name, presence: true, uniqueness: true,
					 								length: { maximum: 45 }
	validates :current_health_point, presence: true,
										numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :max_health_point }, if: :max_health_point_present?
	validates :max_health_point, presence: true,
										numericality: { greater_than: 0 }
	validates :attack, presence: true,
										numericality: { greater_than: 0 }
	validates :defence, presence: true,
										numericality: { greater_than: 0 }
	validates :speed, presence: true,
										numericality: { greater_than: 0 }
	validates :level, presence: true,
										numericality: { greater_than: 0 }
	validates :current_experience, presence: true,
										numericality: { greater_than_or_equal_to: 0 }

	def max_health_point_present?
		max_health_point.present?
	end
end
