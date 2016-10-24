class Trainer < ApplicationRecord
	has_many :trainer_pokemons
	has_many :pokemon, through: :trainer_pokemons
end
