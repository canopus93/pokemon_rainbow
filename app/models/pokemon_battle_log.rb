class PokemonBattleLog < ApplicationRecord
	extend Enumerize

	ATTACK_ACTION = 'attack'.freeze
	SURRENDER_ACTION = 'surrender'.freeze

	ACTION_TYPE_LIST = [ATTACK_ACTION, SURRENDER_ACTION]

	belongs_to :pokemon_battle
	belongs_to :attacker, class_name: 'Pokemon',
												foreign_key: 'attacker_id'
	belongs_to :defender, class_name: 'Pokemon',
												foreign_key: 'defender_id'

	enumerize :action_type, in: ACTION_TYPE_LIST

	validates :pokemon_battle_id, presence: true
	validates :skill_name, presence: true,
										length: { maximum: 45 }
	validates :turn, presence: true,
										numericality: { greater_than: 0 }
	validates :damage, presence: true,
										numericality: { greater_than_or_equal_to: 0 }
	validates :attacker_id, presence: true
	validates :attacker_current_health_point, presence: true,
										numericality: { greater_than_or_equal_to: 0 }
	validates :defender_id, presence: true
	validates :defender_current_health_point, presence: true,
										numericality: { greater_than_or_equal_to: 0 }
	validates :action_type, presence: true,
										length: { maximum: 45 }
end
