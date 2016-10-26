require 'rails_helper'

RSpec.describe Pokemon, type: :model do
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
  end

  it "should be true when save new pokemon" do
  	new_pokemon = Pokemon.new(
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

  	expect(new_pokemon.save).to eq(true)
  end

  describe "Default validation :" do
    it "should be false when pokedex is blank" do
    	new_pokemon = Pokemon.new(
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when pokedex is not exist" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: Pokedex.new,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when name blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when name is not unique" do
    	first_pokemon = Pokemon.new(
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
    	first_pokemon.save!

    	new_pokemon = Pokemon.new(
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

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when name length > 45" do
    	new_pokemon = Pokemon.new(
    		name: 'rspec test name length greater than 45 char_scenario',
    		pokedex_id: @pokedex.id,
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when current_health_point is blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when current_health_point is not number" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 'a',
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when current_health_point < 0" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: -22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when current_health_point > max_health_point" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 23,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when max_health_point is blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when max_health_point is not number" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 'a',
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when max_health_point <= 0" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 0,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when attack is blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when attack is not number" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 'a',
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when attack <= 0" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 0,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when defence is blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when defence is not number" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 'a',
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when defence <= 0" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 0,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when speed is blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when speed is not number" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 'a',
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when speed <= 0" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 0,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when level is blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when level is not number" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 'a',
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when level <= 0" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 0,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 0
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when current_experience is blank" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when current_experience is not number" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: 'a'
    	)

    	expect(new_pokemon.save).to eq(false)
    end

    it "should be false when current_experience < 0" do
    	new_pokemon = Pokemon.new(
    		pokedex_id: @pokedex.id,
    		name: 'new pokemon',
    		level: 1,
    		current_health_point: 22,
    		max_health_point: 22,
    		attack: 22,
    		defence: 22,
    		speed: 22,
    		current_experience: -22
    	)

    	expect(new_pokemon.save).to eq(false)
    end
  end
end
