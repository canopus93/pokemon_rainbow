require 'rails_helper'

RSpec.describe PokemonEvolution, type: :model do
	before(:each) do
		@pokedex_from = Pokedex.new(
  		name: 'pokedex from',
  		base_health_point: 22,
  		base_attack: 22,
  		base_defence: 22,
  		base_speed: 22,
  		element_type: 'normal',
  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
  	)
  	@pokedex_from.save

  	@pokedex_to = Pokedex.new(
  		name: 'pokedex to',
  		base_health_point: 44,
  		base_attack: 44,
  		base_defence: 44,
  		base_speed: 44,
  		element_type: 'normal',
  		image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
  	)
  	@pokedex_to.save

  	@pokedex_evolution = PokedexEvolution.new(
  		pokedex_from_id: @pokedex_from.id,
  		pokedex_to_id: @pokedex_to.id,
  		minimum_level: 16
  	)
  	@pokedex_evolution.save
	end

  it "should be true when pokemon is able to evolve" do
  	pokemon = Pokemon.new(
  		pokedex_id: @pokedex_from.id,
  		name: 'new pokemon',
  		level: 17,
  		current_health_point: 22,
  		max_health_point: 22,
  		attack: 22,
  		defence: 22,
  		speed: 22,
  		current_experience: 0
  	)
  	pokemon.save

  	expect(PokemonEvolution.able_to_evolve?(pokemon)).to eq(true)
  end

  it "should be true when pokemon have evolved" do
  	pokemon = Pokemon.new(
  		pokedex_id: @pokedex_from.id,
  		name: 'new pokemon',
  		level: 17,
  		current_health_point: 22,
  		max_health_point: 22,
  		attack: 22,
  		defence: 22,
  		speed: 22,
  		current_experience: 0
  	)
  	pokemon.save

  	PokemonEvolution.evolve!(pokemon)

  	expect(pokemon.pokedex_id).to eq(@pokedex_to.id)
  end

  it "should be true when pokemon_skill count become 1 after add skill" do
    pokemon = Pokemon.new(
      pokedex_id: @pokedex_from.id,
      name: 'new pokemon',
      level: 17,
      current_health_point: 22,
      max_health_point: 22,
      attack: 22,
      defence: 22,
      speed: 22,
      current_experience: 0
    )
    pokemon.save

    skill = Skill.new(
      name: 'new skill',
      power: 22,
      max_pp: 22,
      element_type: 'normal'
    )
    skill.save

    PokemonEvolution.add_skill_after_evolve(pokemon: pokemon, skill_to_add: skill)

    expect(pokemon.pokemon_skills.count).to eq(1)
  end
end
