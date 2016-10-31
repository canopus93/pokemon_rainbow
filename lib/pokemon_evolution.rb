class PokemonEvolution
	YES = 'yes'
	NO = 'no'
	def self.able_to_evolve?(pokemon)
		if pokemon.present?
			pokedex_evolution = PokedexEvolution.find_by(pokedex_from_id:  pokemon.pokedex_id)
			if pokedex_evolution.present?
				(pokemon.level >= pokedex_evolution.minimum_level)
			else
				false
			end
		else
			false
		end
	end

	def self.evolve!(pokemon)
		if able_to_evolve?(pokemon)
			pokedex_evolution = PokedexEvolution.find_by(pokedex_from_id:  pokemon.pokedex_id)
			update_status_after_evolve(pokemon: pokemon, pokedex_evolution: pokedex_evolution)
			# generate_random_skill(pokemon)
			pokemon.pokedex_id = pokedex_evolution.pokedex_to_id
			pokemon.save
		end
	end
	
	def self.add_skill_after_evolve(pokemon:, skill_to_add:, skill_to_remove: nil)
		ActiveRecord::Base.transaction do
			if skill_to_remove.present?
				skill_to_remove.destroy
			end
			pokemon_skill = PokemonSkill.new(pokemon: pokemon, skill: skill_to_add, current_pp: skill_to_add.max_pp)
			pokemon_skill.save
		end
	end

	private

	def self.update_status_after_evolve(pokemon:, pokedex_evolution:)
		old_pokedex = Pokedex.find(pokemon.pokedex_id)
		new_pokedex = Pokedex.find(pokedex_evolution.pokedex_to_id)

		new_health_point = new_pokedex.base_health_point - old_pokedex.base_health_point
		new_attack = new_pokedex.base_attack - old_pokedex.base_attack
		new_defence = new_pokedex.base_defence - old_pokedex.base_defence
		new_speed = new_pokedex.base_speed - old_pokedex.base_speed

		pokemon.max_health_point += (new_health_point > 0) ? new_health_point : 0
		pokemon.current_health_point = pokemon.max_health_point
		pokemon.attack += (new_attack > 0) ? new_attack : 0
		pokemon.defence += (new_defence > 0) ? new_defence : 0
		pokemon.speed += (new_speed > 0) ? new_speed : 0
	end

	def self.generate_random_skill(pokemon)
		pokemon_current_skills = PokemonSkill.where(pokemon_id: pokemon.id).pluck(:skill_id)
		random_skill = Skill.where.not(id: pokemon_current_skills).sample
		new_pokemon_skill = PokemonSkill.new(pokemon: pokemon, skill: random_skill, current_pp: random_skill.max_pp)
		new_pokemon_skill.save
	end
end