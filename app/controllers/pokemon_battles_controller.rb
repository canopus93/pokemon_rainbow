class PokemonBattlesController < ApplicationController
	def index
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battles = decorator.decorate_for_index(PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battle = decorator.decorate_for_show(PokemonBattle.find(params[:id]))
		@pokemon_battle_log = PokemonBattleLog.new
	end

	def new
		@pokemon_battle = PokemonBattle.new
	end

	def action
		pokemon_battle = PokemonBattle.find(params[:id])
		pokemon_skill = (params[:pokemon_skill_id].present?) ? PokemonSkill.find(params[:pokemon_skill_id]) : PokemonSkill.new

		battle_engine = BattleEngine.new(
			pokemon_battle: pokemon_battle,
			pokemon_skill: pokemon_skill,
			action_type: params[:action_type]
		)

		if battle_engine.valid?
			battle_engine.execute
			redirect_to pokemon_battle_path(params[:id])
		else
			@pokemon_battle_log = battle_engine.pokemon_battle_log
			decorator = PokemonBattlesDecorator.new(self)
			@decorated_pokemon_battle = decorator.decorate_for_show(pokemon_battle)
			render 'show'
		end
	end

	def create
		@pokemon_battle = PokemonBattle.new(pokemon_battle_params)
		@pokemon_battle.pokemon1_max_health_point = Pokemon.find(params[:pokemon_battle][:pokemon1_id]).max_health_point if params[:pokemon_battle][:pokemon1_id].present?
		@pokemon_battle.pokemon2_max_health_point = Pokemon.find(params[:pokemon_battle][:pokemon2_id]).max_health_point if params[:pokemon_battle][:pokemon2_id].present?

		if @pokemon_battle.save
			redirect_to @pokemon_battle
		else
			render 'new'
		end
	end

	def destroy
		@pokemon_battle = PokemonBattle.find(params[:id])
		@pokemon_battle.destroy

		redirect_to pokemon_battles_path
	end

	private
		def pokemon_battle_params
			params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id, :state, :current_turn)
		end
end
