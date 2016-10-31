class PokemonBattlesController < ApplicationController

	add_breadcrumb "Pokemon Battles", :pokemon_battles_path

	def index
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battles = decorator.decorate_for_index(PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_pokemon_battles = PokemonBattle.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = PokemonBattlesDecorator.new(self)
		@decorated_pokemon_battle = decorator.decorate_for_show(PokemonBattle.find(params[:id]))
		@errors = {skill: '', action_type: ''}
		add_breadcrumb "#{@decorated_pokemon_battle.pokemon1.name} vs #{@decorated_pokemon_battle.pokemon2.name}"
	end

	def new
		@pokemon_battle = PokemonBattle.new
		add_breadcrumb 'New'
	end

	def action
		pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
		pokemon_skill = (params[:pokemon_skill_id].present?) ? PokemonSkill.find(params[:pokemon_skill_id]) : PokemonSkill.new()

		battle_engine = BattleEngine.new(pokemon_battle)

		if battle_engine.valid_next_turn?(pokemon_skill: pokemon_skill, action_type: params[:action_type])
			ActiveRecord::Base.transaction do
				battle_engine.next_turn!(pokemon_skill)
				battle_engine.save!
				if(pokemon_battle.battle_type == PokemonBattle::VERSUS_AI_BATTLE_TYPE)
					auto_battle_engine = AutoBattleEngine.new(pokemon_battle: pokemon_battle)
					auto_battle_engine.execute_enemy_ai(battle_engine)
				end
			end

			if pokemon_battle.state == PokemonBattle::FINISH_STATE && PokemonEvolution.able_to_evolve?(pokemon_battle.pokemon_winner)
				redirect_to pokemon_battle_evolution_confirmation_path(pokemon_battle.id)
			else
				redirect_to pokemon_battle
			end
		else
			@errors = battle_engine.errors
			decorator = PokemonBattlesDecorator.new(self)
			@decorated_pokemon_battle = decorator.decorate_for_show(pokemon_battle)
			render 'show'
		end
	end

	def evolution_confirmation
		@pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
	end

	def evolve
		pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
		if params[:confirmation] == PokemonEvolution::YES
			PokemonEvolution.evolve!(pokemon_battle.pokemon_winner)
			redirect_to pokemon_battle_choose_skill_path(pokemon_battle.id)
		else
			redirect_to pokemon_battle
		end
	end

	def choose_skill
		@pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
		@pokemon_skills = PokemonSkill.where(pokemon_id: @pokemon_battle.pokemon_winner.id)
		@errors = {skill_to_add: '', skill_to_remove: ''}
	end

	def submit_skill
		@errors = {skill_to_add: '', skill_to_remove: ''}
		@pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
		@pokemon_skills = PokemonSkill.where(pokemon_id: @pokemon_battle.pokemon_winner.id)
		if params[:submit_action] == 'cancel'
			redirect_to @pokemon_battle
		else
			if params[:skill_to_add].present?
				skill_to_add = Skill.find_by(id: params[:skill_to_add])
				if params[:skill_to_remove].present? && @pokemon_skills.count == 4
					skill_to_remove = PokemonSkill.find(params[:skill_to_remove])
					PokemonEvolution.add_skill_after_evolve(
						pokemon: @pokemon_battle.pokemon_winner,
						skill_to_add: skill_to_add,
						skill_to_remove: skill_to_remove
					)
					redirect_to @pokemon_battle
				elsif !params[:skill_to_remove].present? && @pokemon_skills.count == 4
					@errors[:skill_to_remove] = 'must be chosen'
					render 'choose_skill'
				else
					PokemonEvolution.add_skill_after_evolve(pokemon: @pokemon_battle.pokemon_winner, skill_to_add: skill_to_add)
					redirect_to @pokemon_battle
				end
			else
				@errors[:skill_to_add] = 'must be chosen'
				render 'choose_skill'
			end
		end
	end

	def auto_battle
		pokemon_battle = PokemonBattle.find(params[:pokemon_battle_id])
		pokemon_battle.battle_type = PokemonBattle::AUTO_BATTLE_TYPE
		pokemon_battle.save
			
		ActiveRecord::Base.transaction do
			auto_battle_engine = AutoBattleEngine.new(pokemon_battle: pokemon_battle)
			auto_battle_engine.execute
		end

		if pokemon_battle.state == PokemonBattle::FINISH_STATE && PokemonEvolution.able_to_evolve?(pokemon_battle.pokemon_winner)
			redirect_to pokemon_battle_evolution_confirmation_path(pokemon_battle.id)
		else
			redirect_to pokemon_battle
		end
	end

	def create
		@pokemon_battle = PokemonBattle.new(pokemon_battle_params)
		@pokemon_battle.state = PokemonBattle::ONGOING_STATE
		@pokemon_battle.current_turn = 1
		@pokemon_battle.battle_type = params[:battle_type]

		@pokemon_battle.pokemon1_max_health_point = Pokemon.find(params[:pokemon_battle][:pokemon1_id]).max_health_point if params[:pokemon_battle][:pokemon1_id].present?
		@pokemon_battle.pokemon2_max_health_point = Pokemon.find(params[:pokemon_battle][:pokemon2_id]).max_health_point if params[:pokemon_battle][:pokemon2_id].present?

		if @pokemon_battle.save
			if @pokemon_battle.battle_type == PokemonBattle::AUTO_BATTLE_TYPE
				redirect_to pokemon_battle_auto_battle_path(@pokemon_battle.id)
			else
				redirect_to @pokemon_battle
			end
		else
			render 'new'
		end
	end

	private
		def pokemon_battle_params
			params.require(:pokemon_battle).permit(:pokemon1_id, :pokemon2_id)
		end
end
