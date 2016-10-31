require 'rails_helper'

RSpec.describe AutoBattleEngine, type: :model do
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

  it "Pokemon1 should win when have same data but have higher HP" do
  	skill1 = create_skill(name: 'skill1', power: 10)
  	pokemon1 = create_pokemon(pokedex: @pokedex, name: 'pokemon1', max_health_point: 100)
  	pokemon2 = create_pokemon(pokedex: @pokedex, name: 'pokemon2', max_health_point: 50)
  	create_pokemon_skill(skill: skill1, pokemon: pokemon1)
  	create_pokemon_skill(skill: skill1, pokemon: pokemon2)

  	pokemon_battle = create_pokemon_battle(pokemon1: pokemon1, pokemon2: pokemon2)

  	auto_battle_engine = AutoBattleEngine.new(pokemon_battle: pokemon_battle)
  	auto_battle_engine.execute

  	expect(pokemon_battle.pokemon_winner).to eq(pokemon1)
  end

  it "Pokemon2 should win when have lower HP but have skill with better damage" do
  	skill1 = create_skill(name: 'skill1', power: 10)
  	skill2 = create_skill(name: 'skill2', power: 90)
  	pokemon1 = create_pokemon(pokedex: @pokedex, name: 'pokemon1', max_health_point: 100)
  	pokemon2 = create_pokemon(pokedex: @pokedex, name: 'pokemon2', max_health_point: 50)
  	create_pokemon_skill(skill: skill1, pokemon: pokemon1)
  	create_pokemon_skill(skill: skill2, pokemon: pokemon2)

  	pokemon_battle = create_pokemon_battle(pokemon1: pokemon1, pokemon2: pokemon2)

  	auto_battle_engine = AutoBattleEngine.new(pokemon_battle: pokemon_battle)
  	auto_battle_engine.execute

  	expect(pokemon_battle.pokemon_winner).to eq(pokemon2)
  end

  it "Pokemon1 should win when pokemon2 does not have any skill" do
  	skill1 = create_skill(name: 'skill1', power: 10)
  	pokemon1 = create_pokemon(pokedex: @pokedex, name: 'pokemon1', max_health_point: 100)
  	pokemon2 = create_pokemon(pokedex: @pokedex, name: 'pokemon2', max_health_point: 50)
  	create_pokemon_skill(skill: skill1, pokemon: pokemon1)

  	pokemon_battle = create_pokemon_battle(pokemon1: pokemon1, pokemon2: pokemon2)

  	auto_battle_engine = AutoBattleEngine.new(pokemon_battle: pokemon_battle)
  	auto_battle_engine.execute

  	expect(pokemon_battle.pokemon_winner).to eq(pokemon1)
  end

  it "Pokemon2 should win when both pokemon do not have any skill" do
  	pokemon1 = create_pokemon(pokedex: @pokedex, name: 'pokemon1', max_health_point: 100)
  	pokemon2 = create_pokemon(pokedex: @pokedex, name: 'pokemon2', max_health_point: 50)

  	pokemon_battle = create_pokemon_battle(pokemon1: pokemon1, pokemon2: pokemon2)

  	auto_battle_engine = AutoBattleEngine.new(pokemon_battle: pokemon_battle)
  	auto_battle_engine.execute

  	expect(pokemon_battle.pokemon_winner).to eq(pokemon2)
  end




  def create_skill(name:, power:)
  	skill = Skill.new(
			name: name,
			power: power,
			max_pp: 200,
			element_type: 'normal'
		)
		skill.save
		skill
  end

  def create_pokemon_battle(pokemon1:, pokemon2:)
		pokemon_battle = PokemonBattle.new(
  		pokemon1_id: pokemon1.id,
  		pokemon2_id: pokemon2.id,
  		current_turn: 1,
  		state: 'ongoing',
      battle_type: PokemonBattle::AUTO_BATTLE_TYPE,
  		pokemon1_max_health_point: pokemon1.max_health_point,
  		pokemon2_max_health_point: pokemon2.max_health_point
  	)
  	pokemon_battle.save
  	pokemon_battle
  end

  def create_pokemon(pokedex:, name:, max_health_point:)
  	pokemon = Pokemon.new(
			pokedex_id: pokedex.id,
			name: name,
			level: 1,
			current_health_point: max_health_point,
			max_health_point: max_health_point,
			attack: 10,
			defence: 10,
			speed: 10,
			current_experience: 0
		)
		pokemon.save
		pokemon
  end

  def create_pokemon_skill(skill:, pokemon:)
  	pokemon_skill = PokemonSkill.new(
  		skill_id: skill.id,
  		pokemon_id: pokemon.id,
  		current_pp: skill.max_pp
  	)
  	pokemon_skill.save
  end
end
