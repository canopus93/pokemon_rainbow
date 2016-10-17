class Skill < ApplicationRecord
	validates :name, presence: true, uniqueness: true,
					 								length: { maximum: 45 }
	validates :power, presence: true,
											numericality: { greater_than: 0 }
	validates :max_pp, presence: true,
											numericality: { greater_than: 0 }
	validates :element_type, presence: true
end
