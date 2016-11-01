class TrainersController < ApplicationController

	add_breadcrumb "Trainers", :trainers_path

	def index
		decorator = TrainersDecorator.new(self)
		@decorated_trainers = decorator.decorate_for_index(Trainer.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_trainers = Trainer.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = TrainersDecorator.new(self)
		@decorated_trainer = decorator.decorate_for_show(Trainer.find(params[:id]))
		@trainer_pokemon = TrainerPokemon.new
		add_breadcrumb @decorated_trainer.name
	end

	def new
		@trainer = Trainer.new
		add_breadcrumb 'New'
	end

	def edit
		@trainer = Trainer.find(params[:id])
		add_breadcrumb @trainer.name, @trainer
		add_breadcrumb 'Edit'
	end

	def create
		@trainer = Trainer.new(trainer_params)

		if @trainer.save
			redirect_to @trainer
		else
			render 'new'
		end
	end

	def update
		@trainer = Trainer.find(params[:id])

		if @trainer.update(trainer_params)
			redirect_to @trainer
		else
			render 'edit'
		end
	end

	def destroy
		@trainer = Trainer.find(params[:id])
		@trainer.destroy

		redirect_to trainers_path
	end

	def add_pokemon
		trainer = Trainer.find(params[:trainer_id])
		pokemon = Pokemon.find_by(id: params[:trainer_pokemon][:pokemon_id])
		@trainer_pokemon = TrainerPokemon.new(trainer: trainer, pokemon: pokemon)

		decorator = TrainersDecorator.new(self)
		@decorated_trainer = decorator.decorate_for_show(trainer)

		if @trainer_pokemon.save
			redirect_to trainer
		else
			render 'show'
		end
	end

	def remove_pokemon
		TrainerPokemon.find(params[:trainer_pokemon_id])
									.destroy

		redirect_to trainer_path(params[:trainer_id])
	end

	private
		def trainer_params
			params.require(:trainer).permit(:name, :email)
		end
end
