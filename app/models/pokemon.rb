class Pokemon < ApplicationRecord
	belongs_to :pokedex

	validates :name, presence: true, uniqueness: true,
					 								length: { maximum: 45 }
	validates :current_health_point, presence: true,
										numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: :max_health_point }
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
end
