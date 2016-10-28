class PokemonRainbowStatistic
	PokemonRainbowStatisticPokemonResult = Struct.new(
		:id,
		:pokemon_id,
		:name,
		:level,
		:count
	)

	def self.top_ten_pokemon_winner
		pokemons = base_connection.execute("
			SELECT pokemons.name, count(pokemons.id) as win_count
				FROM pokemons
			INNER JOIN pokemon_battles
				ON pokemons.id = pokemon_battles.pokemon_winner_id
			GROUP BY pokemons.id
			ORDER BY win_count DESC
			LIMIT 10
		")

		results = []
		pokemons.each do |pokemon|
			results << { name: pokemon['name'], data: [pokemon['win_count']] }
		end
		results
	end

	def self.top_ten_pokemon_loser
		pokemons = base_connection.execute("
			SELECT pokemons.name, count(pokemons.id) as lose_count
				FROM pokemons
			INNER JOIN pokemon_battles
				ON pokemons.id = pokemon_battles.pokemon_loser_id
			GROUP BY pokemons.id
			ORDER BY lose_count DESC
			LIMIT 10
		")

		results = []
		pokemons.each do |pokemon|
			results << { name: pokemon['name'], data: [pokemon['lose_count']] }
		end
		results
	end

	def self.top_ten_pokemon_surrender
		results = []
		surrender_action = PokemonBattleLog::SURRENDER_ACTION
		pokemons = base_connection.execute("
			SELECT pokemons.name, count(pokemons.id) as surrender_count
				FROM pokemons
			INNER JOIN pokemon_battle_logs
				ON pokemons.id = pokemon_battle_logs.attacker_id
			WHERE pokemon_battle_logs.action_type = '#{surrender_action}'
			GROUP BY pokemons.id
			ORDER BY surrender_count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << { name: pokemon['name'], data: [pokemon['surrender_count']] }
		end
		results
	end

	def self.top_ten_pokemon_win_rate
		results = []
		pokemons = base_connection.execute("
			SELECT
				pokemons.name,
				pokemons.battle_count,
				count(pokemon_battles.id) AS win_count,
				100*count(pokemon_battles.id)/battle_count AS win_rate
			FROM (
				SELECT pokemons.id, pokemons.name, count(*) AS battle_count
				FROM pokemons
				INNER JOIN pokemon_battles
				ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
				GROUP BY pokemons.id
			) pokemons
			LEFT OUTER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon_winner_id
			GROUP BY pokemons.id, pokemons.name, pokemons.battle_count, pokemon_battles.pokemon_winner_id
			ORDER BY win_rate DESC, battle_count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << { name: pokemon['name'], data: [pokemon['win_rate']] }
		end
		results
	end

	def self.top_ten_pokemon_lose_rate
		results = []
		pokemons = base_connection.execute("
			SELECT
				pokemons.name,
				pokemons.battle_count,
				count(pokemon_battles.id) AS lose_count,
				100*count(pokemon_battles.id)/battle_count AS lose_rate
			FROM (
				SELECT pokemons.id, pokemons.name, count(*) AS battle_count
				FROM pokemons
				INNER JOIN pokemon_battles
				ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
				GROUP BY pokemons.id
			) pokemons
			LEFT OUTER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon_loser_id
			GROUP BY pokemons.id, pokemons.name, pokemons.battle_count, pokemon_battles.pokemon_loser_id
			ORDER BY lose_rate DESC, battle_count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << { name: pokemon['name'], data: [pokemon['lose_rate']] }
		end
		results
	end

	def self.top_ten_pokemon_used_in_battle
		results = []
		pokemons = base_connection.execute("
			SELECT pokemons.name, count(pokemons.id) as battle_count
			FROM pokemons
			INNER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
			GROUP BY pokemons.id
			ORDER BY battle_count DESC
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << { name: pokemon['name'], data: [pokemon['battle_count']] }
		end
		results
	end

	def self.top_ten_skill_used_in_battle
		results = []
		skills = base_connection.execute("
			SELECT skill_name, count(skill_name) as use_count
			FROM pokemon_battle_logs
			WHERE skill_name != '#{PokemonBattleLog::SURRENDER_ACTION}'
			GROUP BY skill_name
			ORDER BY use_count DESC
			LIMIT 10
		")

		skills.each do |skill|
			results << { name: skill['name'], data: [skill['use_count']] }
		end
		results
	end

	def self.top_ten_pokemon_with_biggest_total_damage
		results = []
		pokemons = base_connection.execute("
			SELECT pokemons.name, sum(pokemon_battle_logs.damage) AS damage_sum
			FROM pokemons
			INNER JOIN pokemon_battle_logs
			ON pokemons.id = pokemon_battle_logs.attacker_id
			GROUP BY pokemons.id
			ORDER BY damage_sum DESC, pokemons.level
			LIMIT 10
		")

		pokemons.each do |pokemon|
			results << { name: pokemon['name'], data: [pokemon['damage_sum']] }
		end
		results
	end

	def self.generate_sorted_trainer_pokemons(trainer_id)
		results = []
		pokemons = base_connection.execute("
			SELECT trainer_pokemons.id, pokemons.id as pokemon_id, pokemons.name, pokemons.level, count(pokemon_battles.id)
			FROM pokemons
			INNER JOIN trainer_pokemons
			ON pokemons.id = trainer_pokemons.pokemon_id
			LEFT OUTER JOIN pokemon_battles
			ON pokemons.id = pokemon_battles.pokemon1_id OR pokemons.id = pokemon_battles.pokemon2_id
			WHERE trainer_pokemons.trainer_id = #{trainer_id}
			GROUP BY pokemons.id, trainer_pokemons.id
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
			SELECT pokedexes.name, AVG(pokemons.level) AS average_level
			FROM pokedexes
			LEFT OUTER JOIN pokemons
			ON pokedexes.id = pokemons.pokedex_id
			GROUP BY pokedexes.id
			ORDER BY average_level DESC, count(pokemons.id) DESC
			LIMIT 10
		")

		pokedexes.each do |pokedex|
			results << { name: pokedex['name'], data: [pokedex['average_level'].to_f] }
		end
		results
	end

	private

	def self.generate_pokemon_rainbow_statistic_pokemon_result(pokemon)
		result = PokemonRainbowStatisticPokemonResult.new
		result.id = pokemon['id']
		result.pokemon_id = pokemon['pokemon_id']
		result.name = pokemon['name']
		result.level = pokemon['level']
		result.count = pokemon['count']

		result
	end

  def self.base_connection
  	@base_connection ||= ActiveRecord::Base.connection
  end
end