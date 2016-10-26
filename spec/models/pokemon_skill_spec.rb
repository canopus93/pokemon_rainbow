require 'rails_helper'

RSpec.describe PokemonSkill, type: :model do
	before(:each) do
		@pokedex = Pokedex.new(
			name: 'new pokedex',
			base_health_point: 22,
			base_attack: 22,
			base_defence: 22,
			base_speed: 22,
			element_type: 'normal',
			image_url: 'https://img.pokemondb.net/artwork/jirachi.jpg'
		)
		@pokedex.save
		@skill = Skill.new(
			name: 'new skill',
			power: 22,
			max_pp: 22,
			element_type: 'normal'
		)
		@skill.save
		@pokemon = Pokemon.new(
			pokedex_id: @pokedex.id,
			name: 'new pokemon',
			level: 1,
			current_health_point: 22,
			max_health_point: 22,
			attack: 22,
			defence: 22,
			speed: 22,
			current_experience: 0
		)
		@pokemon.save
	end

  it "should be true when save new pokemon_skill" do
  	new_pokemon_skill = PokemonSkill.new(
  		skill_id: @skill.id,
  		pokemon_id: @pokemon.id,
  		current_pp: 1
  	)
  	new_pokemon_skill.save!

  	expect(new_pokemon_skill.save).to eq(true)
  end

  describe "Default validation :" do
    it "should be false when skill_id is blank" do
    	new_pokemon_skill = PokemonSkill.new(
    		pokemon_id: @pokemon.id,
    		current_pp: 1
    	)

    	expect(new_pokemon_skill.save).to eq(false)
    end

    it "should be false when skill_id is not unique" do
    	first_pokemon_skill = PokemonSkill.new(
    		skill_id: @skill.id,
    		pokemon_id: @pokemon.id,
    		current_pp: 1
    	)
    	first_pokemon_skill.save

    	new_pokemon_skill = PokemonSkill.new(
    		skill_id: @skill.id,
    		pokemon_id: @pokemon.id,
    		current_pp: 1
    	)

    	expect(new_pokemon_skill.save).to eq(false)
    end

    it "should be false when pokemon_id is blank" do
    	new_pokemon_skill = PokemonSkill.new(
    		skill_id: @skill.id,
    		current_pp: 1
    	)

    	expect(new_pokemon_skill.save).to eq(false)
    end

    it "should be false when current_pp is blank" do
    	new_pokemon_skill = PokemonSkill.new(
    		skill_id: @skill.id,
    		pokemon_id: @pokemon.id
    	)

    	expect(new_pokemon_skill.save).to eq(false)
    end

    it "should be false when current_pp is not number" do
    	new_pokemon_skill = PokemonSkill.new(
    		skill_id: @skill.id,
    		pokemon_id: @pokemon.id,
    		current_pp: 'a'
    	)

    	expect(new_pokemon_skill.save).to eq(false)
    end

    it "should be false when current_pp < 0" do
    	new_pokemon_skill = PokemonSkill.new(
    		skill_id: @skill.id,
    		pokemon_id: @pokemon.id,
    		current_pp: -1
    	)

    	expect(new_pokemon_skill.save).to eq(false)
    end
  end

  describe "Custom validation :" do
    it "should be false when current_pp > max_pp" do
    	new_pokemon_skill = PokemonSkill.new(
    		skill_id: @skill.id,
    		pokemon_id: @pokemon.id,
    		current_pp: @skill.max_pp + 1
    	)
    	new_pokemon_skill.save

    	expect(new_pokemon_skill.errors.messages[:current_pp].first).to eq("must be less than or equal to #{@skill.max_pp}")
    end
  end
end