class PokemonsDecorator
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper
	include ActionView::Helpers::AssetTagHelper

	PokemonsDecoratorResult = Struct.new(
		:id,
		:pokedex_id,
		:name,
		:level,
		:max_health_point,
		:current_health_point,
		:attack,
		:defence,
		:speed,
		:current_experience,
		:image,
		:image_small,
		:link_to_show,
		:link_to_edit,
		:link_to_delete
	)

	def initialize(context)
		@context = context
	end

	def decorate_for_index(pokemons)
		result = []

		pokemons.each do |pokemon|
			result << generate_decorator_result(pokemon: pokemon)
		end
		result
	end

	def decorate_for_show(pokemon)
		generate_decorator_result(pokemon: pokemon)
	end

	private
		def generate_decorator_result(pokemon:)
			result = PokemonsDecoratorResult.new
			result.id = pokemon.id
			result.pokedex_id = pokemon.pokedex_id
			result.name = pokemon.name
			result.level = pokemon.level
			result.max_health_point = pokemon.max_health_point
			result.current_health_point = "#{pokemon.current_health_point} / #{pokemon.max_health_point}"
			result.attack = pokemon.attack
			result.defence = pokemon.defence
			result.speed = pokemon.speed
			result.current_experience = pokemon.current_experience
			result.image = image_tag(pokemon.pokedex.image_url, alt: pokemon.name)
			result.image_small = image_tag(pokemon.pokedex.image_url, alt: pokemon.name, class: "pokemon-img")
			result.link_to_show = link_to_show(pokemon)
			result.link_to_edit = link_to_edit(pokemon)
			result.link_to_delete = link_to_delete(pokemon)
			result
		end

		def link_to_show(pokemon)
			@context.helpers.link_to pokemon.name, pokemon_path(pokemon.id)
		end

		def link_to_edit(pokemon)
			@context.helpers.link_to 'Edit', edit_pokemon_path(pokemon.id), class: 'btn btn-warning'
		end

		def link_to_delete(pokemon)
			@context.helpers.link_to 'Remove', pokemon_path(pokemon.id),
										method: :delete, 
										data: { confirm: "Are you sure to remove #{pokemon.name}?"}, class: 'btn btn-danger'
		end
end