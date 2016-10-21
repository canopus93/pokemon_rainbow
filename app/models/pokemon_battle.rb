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

	validate :pokemon1_and_pokemon2_must_not_same, if: :different_pokemon_1_and_pokemon_2?
	validate :pokemon_still_on_batlle, unless: :different_pokemon_1_and_pokemon_2?

	def pokemon1_and_pokemon2_must_not_same		
		errors.add(:pokemon2, "must not be same as Pokemon1")
	end

	def pokemon_still_on_batlle
		pokemon_id_with_ongoing_battle = PokemonBattle.where(state: 'ongoing')
																		 							.pluck(:pokemon1_id, :pokemon2_id)
																		 							.flatten
																		 							.uniq
		
		errors.add(:pokemon1, "still on battle") if pokemon_id_with_ongoing_battle.include?(pokemon1_id)		
		errors.add(:pokemon2, "still on battle") if pokemon_id_with_ongoing_battle.include?(pokemon2_id)
	end

	def different_pokemon_1_and_pokemon_2?
		pokemon1_id == pokemon2_id
	end
end