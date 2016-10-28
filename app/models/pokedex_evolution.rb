class PokedexEvolution < ApplicationRecord
	belongs_to :pokedex_from, class_name: 'Pokedex',
												foreign_key: 'pokedex_from_id'
	belongs_to :pokedex_to, class_name: 'Pokedex',
												foreign_key: 'pokedex_to_id'

	validates :pokedex_from_id, presence: true
	validates :pokedex_to_id, presence: true
	validates :minimum_level, presence: true,
														numericality: { greater_than: 0 }
end
