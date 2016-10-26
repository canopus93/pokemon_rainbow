require 'rails_helper'

RSpec.describe PokemonBattleLog, type: :model do
  before(:each) do
		@skill = Skill.new(
			name: 'new skill',
			power: 22,
			max_pp: 22,
			element_type: 'normal'
		)
		@skill.save
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
		@pokemon_battle = PokemonBattle.new(
  		pokemon1_id: @pokemon1.id,
  		pokemon2_id: @pokemon2.id,
  		current_turn: 1,
  		state: 'ongoing',
  		pokemon1_max_health_point: @pokemon1.max_health_point,
  		pokemon2_max_health_point: @pokemon2.max_health_point
  	)
  	@pokemon_battle.save
	end

	it "should be true when save new pokemon_battle_log" do
  	new_pokemon_battle_log = PokemonBattleLog.new(
  		pokemon_battle_id: @pokemon_battle.id,
  		turn: 1,
  		skill_id: @skill.id,
  		damage: @skill.power,
  		attacker_id: @pokemon1.id,
  		attacker_current_health_point: @pokemon1.current_health_point,
  		defender_id: @pokemon2.id,
  		defender_current_health_point: @pokemon2.current_health_point,
  		action_type: 'attack'
  	)
  	new_pokemon_battle_log.save!

  	expect(PokemonBattleLog.last).to eq(new_pokemon_battle_log)
  end

  describe "Default validation :" do
		it "should be false when pokemon_battle_id is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when pokemon_battle_id is not exist" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: PokemonBattle.new,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when turn is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when turn is not number" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 'a',
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when turn <= 0" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 0,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when damage is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when damage is not number" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: 'a',
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when damage < 0" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: -1,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when attacker_id is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when attacker_id is not exist" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: Pokemon.new,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when attacker_current_health_point is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when attacker_current_health_point is not number" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: 'a',
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when attacker_current_health_point < 0" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: -1,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when defender_id is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when defender_id is not exist" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: Pokemon.new,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when defender_current_health_point is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when defender_current_health_point is not number" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: 'a',
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when defender_current_health_point < 0" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: -1,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when action_type is blank" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when action_type length > 45" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'rspec test action_type length greater than 45 char scenario'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end

		it "should be false when action_type is not_in_list" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		skill_id: @skill.id,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'not in list'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end
	end

	describe "Custom validation :" do
		it "should be false when attack without skill" do
	  	new_pokemon_battle_log = PokemonBattleLog.new(
	  		pokemon_battle_id: @pokemon_battle.id,
	  		turn: 1,
	  		damage: @skill.power,
	  		attacker_id: @pokemon1.id,
	  		attacker_current_health_point: @pokemon1.current_health_point,
	  		defender_id: @pokemon2.id,
	  		defender_current_health_point: @pokemon2.current_health_point,
	  		action_type: 'attack'
	  	)

	  	expect(new_pokemon_battle_log.save).to eq(false)
	  end
	end
end
