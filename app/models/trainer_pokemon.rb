class TrainerPokemon < ApplicationRecord
	belongs_to :pokemon
	belongs_to :trainer

	validate :pokemon_only_one_trainer, on: :create
	validate :every_trainer_only_five_pokemon, on: :create

	

	def pokemon_only_one_trainer
		pokemons_that_have_trainer = TrainerPokemon.pluck(:pokemon_id)
		errors.add(:pokemon_id, "already have trainer") if pokemons_that_have_trainer.include?(pokemon_id)
	end

	def every_trainer_only_five_pokemon
		pokemon_trainer_count = TrainerPokemon.where(trainer_id: trainer_id).count
		errors.add(:trainer, "already have 5 pokemon") if pokemon_trainer_count == 5
	end
end
