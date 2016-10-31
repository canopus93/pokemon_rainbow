require 'rails_helper'

RSpec.describe PokemonBattle, type: :model do
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
		@pokemon1 = Pokemon.new(
			pokedex_id: @pokedex.id,
			name: 'pokemon1',
			level: 1,
			current_health_point: 22,
			max_health_point: 22,
			attack: 22,
			defence: 22,
			speed: 22,
			current_experience: 0
		)
		@pokemon1.save
		@pokemon2 = Pokemon.new(
			pokedex_id: @pokedex.id,
			name: 'pokemon2',
			level: 1,
			current_health_point: 22,
			max_health_point: 22,
			attack: 22,
			defence: 22,
			speed: 22,
			current_experience: 0
		)
		@pokemon2.save
	end

	it "should be true when save new pokemon_battle" do
  	new_pokemon_battle = PokemonBattle.new(
  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
  		pokemon1_id: @pokemon1.id,
  		pokemon2_id: @pokemon2.id,
  		current_turn: 1,
  		state: 'ongoing',
  		pokemon1_max_health_point: @pokemon1.max_health_point,
  		pokemon2_max_health_point: @pokemon2.max_health_point
  	)

  	expect(new_pokemon_battle.save).to eq(true)
  end

	describe "Default validation :" do
	  it "should be false when state is blank" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when state length > 45" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'rspec test element_type length greater than 45 char scenario',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when state not in list" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'not_in_list',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon1 is blank" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon1 is not exist" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: Pokemon.new,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2 is blank" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2 is not exist" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when current_turn is blank" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when current_turn is not number" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 'a',
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when current_turn <= 0" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 0,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when experience_gain is not number" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		experience_gain: 'a',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon1_max_health_point is blank" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon1_max_health_point is not number" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: 'a',
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon1_max_health_point <= 0" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: 0,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2_max_health_point is blank" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2_max_health_point is not number" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: 'a'
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2_max_health_point <= 0" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: 0
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when battle_type is blank" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when battle_type length > 45" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: 'rspec test element_type length greater than 45 char scenario',
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when battle_type not in list" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: 'not_in_list',
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end
	end

  describe "Custom validation :" do
	  it "should be false when pokemon1 is fainted" do
			@pokemon1.current_health_point = 0
			@pokemon1.save

	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon1 is still on battle" do
	  	pokemon3 = Pokemon.new(
				pokedex_id: @pokedex.id,
				name: 'pokemon3',
				level: 1,
				current_health_point: 22,
				max_health_point: 22,
				attack: 22,
				defence: 22,
				speed: 22,
				current_experience: 0
			)
			pokemon3.save

			first_pokemon_battle = PokemonBattle.new(
				battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: pokemon3.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: pokemon3.max_health_point
	  	)
	  	first_pokemon_battle.save

	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2 same with pokemon1" do
	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon1.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon1.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2 is fainted" do
	  	@pokemon2.current_health_point = 0
	  	@pokemon2.save

	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end

	  it "should be false when pokemon2 is still on battle" do
	  	pokemon3 = Pokemon.new(
				pokedex_id: @pokedex.id,
				name: 'pokemon3',
				level: 1,
				current_health_point: 22,
				max_health_point: 22,
				attack: 22,
				defence: 22,
				speed: 22,
				current_experience: 0
			)
			pokemon3.save

			first_pokemon_battle = PokemonBattle.new(
				battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: pokemon3.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: pokemon3.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)
	  	first_pokemon_battle.save

	  	new_pokemon_battle = PokemonBattle.new(
	  		battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
	  		pokemon1_id: @pokemon1.id,
	  		pokemon2_id: @pokemon2.id,
	  		current_turn: 1,
	  		state: 'ongoing',
	  		pokemon1_max_health_point: @pokemon1.max_health_point,
	  		pokemon2_max_health_point: @pokemon2.max_health_point
	  	)

	  	expect(new_pokemon_battle.save).to eq(false)
	  end
	end
end
