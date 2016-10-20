class PokemonBattle < ApplicationRecord
	belongs_to :pokemon1, class_name: 'Pokemon',
												foreign_key: 'pokemon1_id'
	belongs_to :pokemon2, class_name: 'Pokemon',
												foreign_key: 'pokemon2_id'
	belongs_to :pokemon_winner, class_name: 'Pokemon',
												foreign_key: 'pokemon_winner_id',
												optional: true
	belongs_to :pokemon_loser, class_name: 'Pokemon',
												foreign_key: 'pokemon_loser_id',
												optional: true
	has_many :pokemon_battle_logs

	extend Enumerize

	STATE_LIST = [:ongoing, :finish]

	enumerize :state, in: STATE_LIST

	validate :pokemon1_and_pokemon2_must_not_same

	def pokemon1_and_pokemon2_must_not_same
		if pokemon1_id == pokemon2_id
			errors.add(:pokemon2, "must not be same as Pokemon1")
		end
	end
end