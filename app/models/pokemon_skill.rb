class PokemonSkill < ApplicationRecord
	belongs_to :pokemon
	belongs_to :skill

	validates :skill_id, presence: true,
										uniqueness: { scope: :pokemon_id }
	validates :pokemon_id, presence: true
	validates :current_pp, presence: true,
										numericality: { greater_than_or_equal_to: 0 }
	validate :current_pp_should_be_less_than_or_equal_max_pp, if: :skill_id_present?

	def current_pp_should_be_less_than_or_equal_max_pp
		skill = Skill.find_by(id: self.skill_id) 
		if current_pp.present? && current_pp > skill.max_pp
			errors.add(:current_pp, :invalid_current_pp, message: "must be less than or equal to #{skill.max_pp}" )
		end
	end

	def skill_id_present?
		skill_id.present?
	end
end
