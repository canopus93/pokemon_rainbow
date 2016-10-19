class PokemonBattleLog < ApplicationRecord
	belongs_to :pokemon_battle
	belongs_to :skill, optional: true
	belongs_to :attacker, class_name: 'Pokemon',
												foreign_key: 'attacker_id'
	belongs_to :defender, class_name: 'Pokemon',
												foreign_key: 'defender_id'

	extend Enumerize

	ACTION_TYPE_LIST = [:attack, :surrender]

	enumerize :action_type, in: ACTION_TYPE_LIST
	validate :attack_must_use_skill

	def attack_must_use_skill
		if action_type == 'attack' && skill_id.nil?
			errors.add(:skill_id, "must exist")
		end
	end
end
