class PokedexesController < ApplicationController
	def index
		decorator = PokedexesDecorator.new(self)
		@decorated_pokedexes = decorator.decorate_for_index(Pokedex.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_pokedexes = Pokedex.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = PokedexesDecorator.new(self)
		@decorated_pokedex = decorator.decorate_for_show(Pokedex.find(params[:id]))
	end

	def new
		@pokedex = Pokedex.new
	end

	def edit
		@pokedex = Pokedex.find(params[:id])
	end

	def create
		@pokedex = Pokedex.new(pokedex_params)

		if @pokedex.save
			redirect_to @pokedex
		else
			render 'new'
		end
	end

	def update
		@pokedex = Pokedex.find(params[:id])

		if @pokedex.update(pokedex_params)
			redirect_to @pokedex
		else
			render 'edit'
		end
	end

	def destroy
		@pokedex = Pokedex.find(params[:id])
		@pokedex.destroy

		redirect_to pokedexes_path
	end

	private
		def pokedex_params
			params.require(:pokedex).permit(:name, :base_health_point, :base_attack, :base_defence, :base_speed, :element_type, :image_url)
		end 
end
