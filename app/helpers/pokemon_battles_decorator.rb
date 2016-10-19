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
		:pokemon_winner_id,
		:pokemon_loser_id,
		:experience_gain,
		:pokemon1_max_health_point,
		:pokemon2_max_health_point
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
		generate_decorator_result(pokemon_battle: pokemon_battle)
	end

	private
		def generate_decorator_result(pokemon_battle:)
			pokemon_decorator = PokemonsDecorator.new(@context)

			result = PokemonBattlesDecoratorResult.new
			result.id = pokemon_battle.id
			result.link_to_show_with_pokemon1_name = link_to_show(pokemon_battle: pokemon_battle, pokemon_name: pokemon_battle.pokemon1.name)
			result.link_to_show_with_pokemon2_name = link_to_show(pokemon_battle: pokemon_battle, pokemon_name: pokemon_battle.pokemon2.name)
			result.pokemon1 = pokemon_decorator.decorate_for_show(pokemon_battle.pokemon1)
			result.pokemon2 = pokemon_decorator.decorate_for_show(pokemon_battle.pokemon2)
			result.current_turn = pokemon_battle.current_turn
			result.state = pokemon_battle.state
			result.pokemon_winner_id = pokemon_battle.pokemon_winner_id
			result.pokemon_loser_id = pokemon_battle.pokemon_loser_id
			result.experience_gain = pokemon_battle.experience_gain
			result.pokemon1_max_health_point = pokemon_battle.pokemon1_max_health_point
			result.pokemon2_max_health_point = pokemon_battle.pokemon2_max_health_point

			result
		end

		def link_to_show(pokemon_battle:, pokemon_name:)
			@context.helpers.link_to pokemon_name, pokemon_battle_path(pokemon_battle.id)
		end
end