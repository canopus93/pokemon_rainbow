class PokemonsController < ApplicationController
	def index
		decorator = PokemonsDecorator.new(self)
		@decorated_pokemons = decorator.decorate_for_index(Pokemon.order(id: :ASC))
	end

	def show
		decorator = PokemonsDecorator.new(self)
		@decorated_pokemon = decorator.decorate_for_show(Pokemon.find(params[:id]))
	end

	def new
		@pokemon = Pokemon.new
	end

	def edit
		@pokemon = Pokemon.find(params[:id])
	end

	def create
		@pokemon = Pokemon.new(pokemon_params)

		if @pokemon.save
			redirect_to @pokemon
		else
			render 'new'
		end
	end

	def update
		@pokemon = Pokemon.find(params[:id])

		if @pokemon.update(pokemon_params)
			redirect_to @pokemon
		else
			render 'edit'
		end
	end

	def destroy
		@pokemon = Pokemon.find(params[:id])
		@pokemon.destroy

		redirect_to pokemons_path
	end

	private
		def pokemon_params
			params.require(:pokemon).permit(:pokedex_id, :name, :level, :max_health_point, :current_health_point, :attack, :defence, :speed, :current_experience)
		end
end
