class PokemonBattlesDecorator
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper

	PokemonBattlesDecoratorResult = Struct.new(
		:id,
		:link_to_show_with_pokemon1_name,
		:link_to_show_with_pokemon2_name,
		:pokemon1,
		:pokemon2,
		:current_turn,
		:state,
		:pokemon_winner,
		:pokemon_loser,
		:experience_gain,
		:pokemon1_current_health_point,
		:pokemon2_current_health_point,
		:link_to_log,
		:pokemon1_available_skills,
		:pokemon2_available_skills,
		:link_to_auto_battle
	)

	def initialize(context)
		@context = context
	end

	def decorate_for_index(pokemon_battles)
		result = []

		pokemon_battles.each do |pokemon_battle|
			result << generate_decorator_result(pokemon_battle: pokemon_battle)
		end
		result
	end

	def decorate_for_show(pokemon_battle)
		result = generate_decorator_result(pokemon_battle: pokemon_battle)
		result.pokemon1_available_skills = pokemon_battle.pokemon1.pokemon_skills.where('current_pp > 0')
		result.pokemon2_available_skills = pokemon_battle.pokemon2.pokemon_skills.where('current_pp > 0')
		result.link_to_auto_battle = link_to_auto_battle(pokemon_battle_id: pokemon_battle.id)
		
		result
	end

	private
		def generate_decorator_result(pokemon_battle:)
			pokemon_decorator = PokemonsDecorator.new(@context)

			pokemon_battle_log = PokemonBattleLog.where(pokemon_battle: pokemon_battle)

			if pokemon_battle_log.count == 0
				pokemon1_current_hp = pokemon_battle.pokemon1.current_health_point
				pokemon2_current_hp = pokemon_battle.pokemon2.current_health_point
			elsif pokemon_battle_log.count.odd?
				pokemon1_current_hp = pokemon_battle_log.last.attacker_current_health_point
				pokemon2_current_hp = pokemon_battle_log.last.defender_current_health_point
			elsif !pokemon_battle_log.count.odd?
				pokemon1_current_hp = pokemon_battle_log.last.defender_current_health_point
				pokemon2_current_hp = pokemon_battle_log.last.attacker_current_health_point
			end

			result = PokemonBattlesDecoratorResult.new
			result.id = pokemon_battle.id
			result.link_to_show_with_pokemon1_name = link_to_show(pokemon_battle: pokemon_battle, pokemon_name: pokemon_battle.pokemon1.name)
			result.link_to_show_with_pokemon2_name = link_to_show(pokemon_battle: pokemon_battle, pokemon_name: pokemon_battle.pokemon2.name)
			result.pokemon1 = pokemon_decorator.decorate_for_show(pokemon_battle.pokemon1)
			result.pokemon2 = pokemon_decorator.decorate_for_show(pokemon_battle.pokemon2)
			result.current_turn = pokemon_battle.current_turn
			result.state = pokemon_battle.state
			result.pokemon_winner = link_to_pokemon_winner(pokemon_winner: pokemon_battle.pokemon_winner) if pokemon_battle.pokemon_winner.present?
			result.pokemon_loser = pokemon_battle.pokemon_loser.name if pokemon_battle.pokemon_winner.present?
			result.experience_gain = pokemon_battle.experience_gain
			result.pokemon1_current_health_point = "#{pokemon1_current_hp} / #{pokemon_battle.pokemon1_max_health_point}"
			result.pokemon2_current_health_point = "#{pokemon2_current_hp} / #{pokemon_battle.pokemon2_max_health_point}"
			result.link_to_log = link_to_log(pokemon_battle_id: pokemon_battle.id)

			result
		end

		def link_to_pokemon_winner(pokemon_winner:)
			@context.helpers.link_to pokemon_winner.name, pokemon_path(pokemon_winner.id)
		end

		def link_to_show(pokemon_battle:, pokemon_name:)
			@context.helpers.link_to pokemon_name, pokemon_battle_path(pokemon_battle.id)
		end

		def link_to_log(pokemon_battle_id:)
			@context.helpers.link_to 'Log', pokemon_battle_pokemon_battle_logs_path(pokemon_battle_id), class: 'btn btn-primary'
		end

		def link_to_auto_battle(pokemon_battle_id:)
			@context.helpers.link_to 'Auto Battle', pokemon_battle_auto_battle_path(pokemon_battle_id), class: 'btn btn-primary'
		end
end