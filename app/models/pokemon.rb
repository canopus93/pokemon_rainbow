class Pokemon < ApplicationRecord
	belongs_to :pokedex
	has_many :pokemon_battles, dependent: :destroy
	has_many :pokemon_skills, dependent: :destroy
	has_many :skills, through: :pokemon_skills
	has_many :pokemon_battle_logs, dependent: :destroy
	has_one :trainer_pokemon
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
