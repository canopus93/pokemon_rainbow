class PokemonRainbowStatistic
	PokemonRainbowStatisticPokemonResult = Struct.new(
		:id,
		:name,
		:level,
		:count
	)

	PokemonRainbowStatisticPokedexResult = Struct.new(
		:id,
		:name,
		:pokemon_count,
		:average_level
	)

	PokemonRainbowStatisticSkillResult = Struct.new(
		:id,
		:name,
		:power,
		:element_type,
		:count
	)

	PokemonRainbowStatisticWinRateResult = Struct.new(
		:id,
		:name,
		:level,
		:battle_count,
		:win_count,
		:rate
	)

	PokemonRainbowStatisticLoseRateResult = Struct.new(
		:id,
		:name,
		:level,
		:battle_count,
		:lose_count,
		:rate
	)

	def self.top_ten_pokemon_winner
		results = []
		pokemons = base_connection.execute("
			SELECT p.id, p.name, p.level, count(p.id)
				FROM pokemons p
			INNER JOIN pokemon_battles pb
				ON p.id = pb.pokemon_winner_id
			GROUP BY p.id
			ORDER BY count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		end
		results
	end

	def self.top_ten_pokemon_loser
		results = []
		pokemons = base_connection.execute("
			SELECT p.id, p.name, p.level, count(p.id)
				FROM pokemons p
			INNER JOIN pokemon_battles pb
				ON p.id = pb.pokemon_loser_id
			GROUP BY p.id
			ORDER BY count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		end
		results
	end

	def self.top_ten_pokemon_surrender
		results = []
		surrender_action = PokemonBattleLog::SURRENDER_ACTION
		pokemons = base_connection.execute("
			SELECT p.id, p.name, p.level, count(p.id)
				FROM pokemons p
			INNER JOIN pokemon_battle_logs pbl
				ON p.id = pbl.attacker_id
			WHERE pbl.action_type = '#{surrender_action}'
			GROUP BY p.id
			ORDER BY count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		end
		results
	end

	def self.top_ten_pokemon_win_rate
		results = []
		pokemons = base_connection.execute("
			SELECT
				pokemons.id,
				pokemons.name,
				pokemons.level,
				pokemons.battle_count,
				count(pokemon_battles.id) AS win_count,
				100*count(pokemon_battles.id)/battle_count AS win_rate
			FROM (
				SELECT pokemons.id, pokemons.name, pokemons.level, count(*) AS battle_count
				FROM pokemons
				INNER JOIN pokemon_battles
				ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
				GROUP BY pokemons.id
			) pokemons
			LEFT OUTER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon_winner_id
			GROUP BY pokemons.id, pokemons.name, pokemons.level, pokemons.battle_count, pokemon_battles.pokemon_winner_id
			ORDER BY win_rate DESC, battle_count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_win_rate_result(pokemon)
		end
		results
	end

	def self.top_ten_pokemon_lose_rate
		results = []
		pokemons = base_connection.execute("
			SELECT
				pokemons.id,
				pokemons.name,
				pokemons.level,
				pokemons.battle_count,
				count(pokemon_battles.id) AS lose_count,
				100*count(pokemon_battles.id)/battle_count AS lose_rate
			FROM (
				SELECT pokemons.id, pokemons.name, pokemons.level, count(*) AS battle_count
				FROM pokemons
				INNER JOIN pokemon_battles
				ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
				GROUP BY pokemons.id
			) pokemons
			LEFT OUTER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon_loser_id
			GROUP BY pokemons.id, pokemons.name, pokemons.level, pokemons.battle_count, pokemon_battles.pokemon_loser_id
			ORDER BY lose_rate DESC, battle_count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_lose_rate_result(pokemon)
		end
		results
	end

	def self.top_ten_pokemon_used_in_battle
		results = []
		pokemons = base_connection.execute("
			SELECT pokemons.id, pokemons.name, pokemons.level, count(pokemons.id)
			FROM pokemons
			INNER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
			GROUP BY pokemons.id
			ORDER BY count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		end
		results
	end

	def self.top_ten_skill_used_in_battle
		results = []
		skills = base_connection.execute("
			SELECT skills.id, skills.name, skills.power, skills.element_type, count(skills.id)
			FROM skills
			INNER JOIN pokemon_battle_logs
			ON skills.id = pokemon_battle_logs.skill_id
			GROUP BY skills.id
			ORDER BY count DESC, power DESC
			LIMIT 10
		")

		skills.each do |skill|
			results << generate_pokemon_rainbow_statistic_skill_result(skill)
		end
		results
	end

	def self.top_ten_pokemon_with_biggest_total_damage
		results = []
		pokemons = base_connection.execute("
			SELECT pokemons.id, pokemons.name, pokemons.level, sum(pokemon_battle_logs.damage) AS count
			FROM pokemons
			INNER JOIN pokemon_battle_logs
			ON pokemons.id = pokemon_battle_logs.attacker_id
			GROUP BY pokemons.id
			ORDER BY count DESC, pokemons.level
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		end
		results
	end

	def self.generate_sorted_trainer_pokemons(trainer_id)
		results = []
		pokemons = base_connection.execute("
			SELECT pokemons.id, pokemons.name, pokemons.level, count(pokemon_battles.id)
			FROM pokemons
			INNER JOIN trainer_pokemons
			ON pokemons.id = trainer_pokemons.pokemon_id
			LEFT OUTER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
			WHERE trainer_pokemons.trainer_id = '#{trainer_id}'
			GROUP BY pokemons.id
			ORDER BY count DESC
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		end
		results
	end

	def self.generate_pokemons_of_pokedex(pokedex_id)
		results = []
		pokemons = base_connection.execute("
			SELECT *
			FROM pokemons
			WHERE pokemons.pokedex_id = '#{pokedex_id}'
			ORDER BY pokemons.level DESC
		")

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		end
		results
	end

	def self.top_ten_pokedex_average_level
		results = []
		pokedexes = base_connection.execute("
			SELECT pokedexes.id, pokedexes.name, count(pokemons.id) AS pokemon_count, AVG(pokemons.level) AS average_level
			FROM pokedexes
			LEFT OUTER JOIN pokemons
			ON pokedexes.id = pokemons.pokedex_id
			GROUP BY pokedexes.id
			ORDER BY average_level DESC, pokemon_count DESC
			LIMIT 10
		")

		pokedexes.each do |pokedex|
			results << generate_pokemon_rainbow_statistic_pokedex_result(pokedex)
		end
		results
	end

	private

	def self.generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		result = PokemonRainbowStatisticPokemonResult.new
		result.id = pokemon['id']
		result.name = pokemon['name']
		result.level = pokemon['level']
		result.count = pokemon['count']

		result
	end

	def self.generate_pokemon_rainbow_statistic_pokedex_result(pokedex)
		result = PokemonRainbowStatisticPokedexResult.new
		result.id = pokedex['id']
		result.name = pokedex['name']
		result.pokemon_count = pokedex['pokemon_count']
		result.average_level = BigDecimal.new(pokedex['average_level'])

		result
	end

	def self.generate_pokemon_rainbow_statistic_skill_result(skill)
		result = PokemonRainbowStatisticSkillResult.new
		result.id = skill['id']
		result.name = skill['name']
		result.power = skill['power']
		result.element_type = skill['element_type']
		result.count = skill['count']

		result
	end

	def self.generate_pokemon_rainbow_statistic_win_rate_result(pokemon)
		result = PokemonRainbowStatisticWinRateResult.new
		result.id = pokemon['id']
		result.name = pokemon['name']
		result.level = pokemon['level']
		result.battle_count = pokemon['battle_count']
		result.win_count = pokemon['win_count']
		result.rate = "#{pokemon['win_rate']} %"
		result
	end

	def self.generate_pokemon_rainbow_statistic_lose_rate_result(pokemon)
		result = PokemonRainbowStatisticLoseRateResult.new
		result.id = pokemon['id']
		result.name = pokemon['name']
		result.level = pokemon['level']
		result.battle_count = pokemon['battle_count']
		result.lose_count = pokemon['lose_count']
		result.rate = "#{pokemon['lose_rate']} %"
		result
	end

  def self.base_connection
  	@base_connection ||= ActiveRecord::Base.connection
  end
end