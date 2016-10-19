class PokemonBattle < ApplicationRecord
	belongs_to :pokemon1, class_name: 'Pokemon',
												foreign_key: 'pokemon1_id'
	belongs_to :pokemon2, class_name: 'Pokemon',
												foreign_key: 'pokemon2_id'
	has_many :pokemon_battle_logs

	extend Enumerize

	STATE_LIST = [:ongoing, :finish]

	enumerize :state, in: STATE_LIST

	validates :pokemon1_id, presence: true
	validates :pokemon2_id, presence: true
	validate :pokemon1_and_pokemon2_must_not_same

	def pokemon1_and_pokemon2_must_not_same
		if pokemon1_id == pokemon2_id
			errors.add(:pokemon1_id, "must not be same as Pokemon2")
			errors.add(:pokemon2_id, "must not be same as Pokemon1")
		end
	end
end