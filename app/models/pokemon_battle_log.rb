class PokemonBattleLog < ApplicationRecord
	belongs_to :pokemon_battle
	belongs_to :skill
	belongs_to :attacker, class_name: 'Pokemon',
												foreign_key: 'attacker_id'
	belongs_to :defender, class_name: 'Pokemon',
												foreign_key: 'defender_id'

	extend Enumerize

	ACTION_TYPE_LIST = [:attack, :surrender]

	enumerize :action_type, in: ACTION_TYPE_LIST
end
