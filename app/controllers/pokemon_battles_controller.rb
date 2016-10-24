class PokemonBattlesController < ApplicationController
	def index
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battles = decorator.decorate_for_index(PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battle = decorator.decorate_for_show(PokemonBattle.find(params[:id]))
		@erros = ''
	end

	def new
		@pokemon_battle = PokemonBattle.new
	end

	def action
		pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
		pokemon_skill = (params[:pokemon_skill_id].present?) ? PokemonSkill.find(params[:pokemon_skill_id]) : PokemonSkill.new

		battle_engine = BattleEngine.new(pokemon_battle)

		if battle_engine.valid_next_turn?(pokemon_skill: pokemon_skill, action_type: params[:action_type])
			ActiveRecord::Base.transaction do
				battle_engine.next_turn!(pokemon_skill)
				battle_engine.save!
			end

			redirect_to pokemon_battle
		else
			@errors = battle_engine.errors
			decorator = PokemonBattlesDecorator.new(self)
			@decorated_pokemon_battle = decorator.decorate_for_show(pokemon_battle)
			render 'show'
		end
	end

	def auto_battle
		pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
		auto_battle_engine = AutoBattleEngine.new(pokemon_battle: pokemon_battle)
		auto_battle_engine.execute

		redirect_to pokemon_battle
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

	private
		def pokemon_battle_params
			params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id, :state, :current_turn)
		end
end
