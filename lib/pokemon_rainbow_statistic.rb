class PokemonRainbowStatistic
	include ActionView::Helpers::AssetTagHelper

	PokemonRainbowStatisticResult = Struct.new(
		:id,
		:name,
		:level,
		:count
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
			LIMIT 10"
		)

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_result(pokemon)
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
			LIMIT 10"
		)

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_result(pokemon)
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
			LIMIT 10"
		)

		pokemons.each do |pokemon|
			results << generate_pokemon_rainbow_statistic_result(pokemon)
		end
		results
	end

	private

	def self.generate_pokemon_rainbow_statistic_result(pokemon)
		result = PokemonRainbowStatisticResult.new
		result.id = pokemon['id']
		result.name = pokemon['name']
		result.level = pokemon['level']
		result.count = pokemon['count']

		result
	end

  def self.base_connection
  	@base_connection ||= ActiveRecord::Base.connection
  end
end