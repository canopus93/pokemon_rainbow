class PokemonBattlesController < ApplicationController
	def index
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battles = decorator.decorate_for_index(PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battle = decorator.decorate_for_show(PokemonBattle.find(params[:id]))
	end

	def new
		@pokemon_battle = PokemonBattle.new
	end

	# def edit
	# 	@pokemon_battle = PokemonBattle.find(params[:id])
	# end

	def create
		@pokemon_battle = PokemonBattle.new(pokemon_battle_params)

		if @pokemon_battle.save
			redirect_to @pokemon_battle
		else
			render 'new'
		end
	end

	# def update
	# 	@pokemon_battle = PokemonBattle.find(params[:id])

	# 	if @pokemon_battle.update(pokemon_battle_params)
	# 		redirect_to @pokemon_battle
	# 	else
	# 		render 'edit'
	# 	end
	# end

	def destroy
		@pokemon_battle = PokemonBattle.find(params[:id])
		@pokemon_battle.destroy

		redirect_to pokemon_battles_path
	end

	private
		def pokemon_battle_params
			params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id, :current_turn, :state, :pokemon_winner_id, :pokemon_loser_id, :experience_gain, :pokemon1_max_health_point, :pokemon2_max_health_point)
		end 
end
