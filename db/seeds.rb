# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'csv'

puts 'Seeding Skills...'
skills = CSV.read("#{Rails.root}/lib/tasks/pokemon_rainbow/skills.csv", {headers: true, return_headers: false})
skills.each do |skill|
	skill_data = Skill.new(
		name: skill['name'],
		power: skill['power'],
		max_pp: skill['max_pp'],
		element_type: skill['element_type']
	)
	skill_data.save
end

puts 'Seeding Pokedexes and Pokemons...'
pokedexes = CSV.read("#{Rails.root}/lib/tasks/pokemon_rainbow/pokedexes.csv", {headers: true, return_headers: false})
pokedexes.each do |pokedex|
	pokedex_data = Pokedex.new(
		name: pokedex['name'],
		base_health_point: pokedex['base_health_point'],
		base_attack: pokedex['base_attack'],
		base_defence: pokedex['base_defence'],
		base_speed: pokedex['base_speed'],
		element_type: pokedex['element_type'],
		image_url: pokedex['image_url']
	)
	pokedex_data.save

	pokemon = Pokemon.new(
		pokedex: pokedex_data,
		name: pokedex_data.name,
		level: 1,
		max_health_point: pokedex_data.base_health_point,
		current_health_point: pokedex_data.base_health_point,
		attack: pokedex_data.base_attack,
		defence: pokedex_data.base_defence,
		speed: pokedex_data.base_speed,
		current_experience: 0
	)
	pokemon.save

	skills = Skill.where(element_type: pokedex_data.element_type).sample(4)
	skills.each do |skill|
		skill_data = PokemonSkill.new(
			pokemon: pokemon,
			skill: skill,
			current_pp: skill.max_pp
		)
		skill_data.save
	end
end

puts 'Seeding Evolution Lists...'

pokedexes = Pokedex.all

evolution_lists = CSV.read("#{Rails.root}/lib/tasks/pokemon_rainbow/evolution_lists.csv", {headers: true, return_headers: false})
evolution_lists.each do |evolution_list|
	evolution_list_data = PokedexEvolution.new(
		pokedex_from_id: pokedexes.find{ |pokedex| pokedex.name == evolution_list['pokedex_from_name'] }.id,
		pokedex_to_id: pokedexes.find{ |pokedex| pokedex.name == evolution_list['pokedex_to_name'] }.id,
		minimum_level: evolution_list['minimum_level']
	)
	evolution_list_data.save
end

puts 'Seeding Trainers and Trainer Pokemons'
(1..20).each do |index|
	trainer_data = Trainer.new(
		name: "Trainer no. #{index}",
		email: "trainer#{index}@trainer.trainer"
	)
	trainer_data.save

	# pokemons_that_have_trainer = TrainerPokemon.pluck(:pokemon_id)
	# pokemon_count = rand(1..5)
	# pokemons = Pokemon.where.not(id: pokemons_that_have_trainer).sample(pokemon_count)
	
	pokemons = Pokemon.all.sample(5)	
	pokemons.each do |pokemon|
		trainer_pokemon = TrainerPokemon.new(
			trainer: trainer_data,
			pokemon: pokemon
		)
		trainer_pokemon.save
	end
end