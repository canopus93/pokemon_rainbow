class PokedexesDecorator
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper
	include ActionView::Helpers::AssetTagHelper

	PokedexesDecoratorResult = Struct.new(
		:id,
		:name,
		:base_health_point,
		:base_attack,
		:base_defence,
		:base_speed,
		:element_type,
		:image,
		:image_small,
		:link_to_show,
		:link_to_edit,
		:link_to_delete
	)

	def initialize(context)
		@context = context
	end

	def decorate_for_index(pokedexes)
		result = []

		pokedexes.each do |pokedex|
			result << generate_decorator_result(pokedex: pokedex)
		end
		result
	end

	def decorate_for_show(pokedex)
		generate_decorator_result(pokedex: pokedex)
	end

	private
		def generate_decorator_result(pokedex:)
			result = PokedexesDecoratorResult.new
			result.id = pokedex.id
			result.name = pokedex.name
			result.base_health_point = pokedex.base_health_point
			result.base_attack = pokedex.base_attack
			result.base_defence = pokedex.base_defence
			result.base_speed = pokedex.base_speed
			result.element_type = pokedex.element_type
			result.image = image_tag(pokedex.image_url, alt: pokedex.name)
			result.image_small = image_tag(pokedex.image_url, alt: pokedex.name, class: "pokemon-img")
			result.link_to_show = link_to_show(pokedex)
			result.link_to_edit = link_to_edit(pokedex)
			result.link_to_delete = link_to_delete(pokedex)
			result
		end

		def link_to_show(pokedex)
			@context.helpers.link_to pokedex.name, pokedex_path(pokedex.id)
		end

		def link_to_edit(pokedex)
			@context.helpers.link_to 'Edit', edit_pokedex_path(pokedex.id), class: 'btn btn-primary btn-xs'
		end

		def link_to_delete(pokedex)
			@context.helpers.link_to 'Remove', pokedex_path(pokedex.id),
										method: :delete, 
										data: { confirm: "Are you sure to remove #{pokedex.name}?"}, class: 'btn btn-primary btn-xs'
		end
end