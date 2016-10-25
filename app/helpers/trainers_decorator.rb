class TrainersDecorator
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper

	TrainersDecoratorResult = Struct.new(
		:id,
		:name,
		:email,
		:trainer_pokemons,
		:link_to_show,
		:link_to_edit,
		:link_to_delete,
		:pokemons_to_add
	)

	def initialize(context)
		@context = context
	end

	def decorate_for_index(trainers)
		result = []

		trainers.each do |trainer|
			result << generate_decorator_result(trainer: trainer)
		end
		result
	end

	def decorate_for_show(trainer)
		result = generate_decorator_result(trainer: trainer)
		pokemons_that_have_trainer = TrainerPokemon.pluck(:pokemon_id)
		result.pokemons_to_add = Pokemon.where.not(id: pokemons_that_have_trainer)

		result
	end

	private
		def generate_decorator_result(trainer:)
			result = TrainersDecoratorResult.new
			result.id = trainer.id
			result.name = trainer.name
			result.email = trainer.email
			result.trainer_pokemons = trainer.trainer_pokemons
			result.link_to_show = link_to_show(trainer)
			result.link_to_edit = link_to_edit(trainer)
			result.link_to_delete = link_to_delete(trainer)
			result
		end

		def link_to_show(trainer)
			@context.helpers.link_to trainer.name, trainer_path(trainer.id)
		end

		def link_to_edit(trainer)
			@context.helpers.link_to 'Edit', edit_trainer_path(trainer.id), class: 'btn btn-warning'
		end

		def link_to_delete(trainer)
			@context.helpers.link_to 'Remove', trainer_path(trainer.id),
										method: :delete, 
										data: { confirm: "Are you sure to remove #{trainer.name}?"}, class: 'btn btn-danger'
		end
end