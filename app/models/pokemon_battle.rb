class PokemonBattle < ApplicationRecord
	belongs_to :pokemon1, class_name: 'Pokemon',
												foreign_key: 'pokemon1_id'
	belongs_to :pokemon2, class_name: 'Pokemon',
												foreign_key: 'pokemon2_id'

	extend Enumerize

	STATE_LIST = [:ongoing, :finish]

	enumerize :state, in: STATE_LIST

	validates :pokemon1_id, presence: true
	validates :pokemon2_id, presence: true
end
