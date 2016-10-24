class PokemonBattleLog < ApplicationRecord
	extend Enumerize

	ATTACK_ACTION = 'attack'.freeze
	SURRENDER_ACTION = 'surrender'.freeze

	ACTION_TYPE_LIST = [ATTACK_ACTION, SURRENDER_ACTION]

	belongs_to :pokemon_battle
	belongs_to :skill, optional: true
	belongs_to :attacker, class_name: 'Pokemon',
												foreign_key: 'attacker_id'
	belongs_to :defender, class_name: 'Pokemon',
												foreign_key: 'defender_id'

	enumerize :action_type, in: ACTION_TYPE_LIST

	validate :attack_must_use_skill

	def attack_must_use_skill
		if action_type == ATTACK_ACTION && skill_id.nil?
			errors.add(:skill_id, "must exist")
		end
	end
end
