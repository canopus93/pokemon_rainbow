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

	# def edit
	# 	@pokemon_battle = PokemonBattle.find(params[:id])
	# end

	def action
		action_type = params[:commit].downcase
		if action_type == 'surrender'
			surrender
		elsif action_type == 'attack'
			attack
		else
			render 'show'
		end
	end

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

		def attack
			action_type = params[:commit].downcase
			if params[:attack_skill].empty?
				attack_skill = nil
				power = nil
			else
				attack_skill = Skill.find(params[:attack_skill])
				power = attack_skill.power
			end
			pokemon_battle = PokemonBattle.find(params[:id])
			@pokemon_battle_log = PokemonBattleLog.new()
			@pokemon_battle_log.pokemon_battle = pokemon_battle
			@pokemon_battle_log.turn = params[:current_turn]
			@pokemon_battle_log.skill = attack_skill
			@pokemon_battle_log.damage = power
			@pokemon_battle_log.attacker = Pokemon.find(params[:attacker_id])
			@pokemon_battle_log.defender = Pokemon.find(params[:defender_id])
			@pokemon_battle_log.action_type = action_type
			if @pokemon_battle_log.valid?
				ActiveRecord::Base.transaction do
					pokemon_battle.update(current_turn: params[:current_turn].to_i + 1)
					@pokemon_battle_log.save
				end
				redirect_to pokemon_battle
			else
				decorator = PokemonBattlesDecorator.new(self)
				@decorated_pokemon_battle = decorator.decorate_for_show(PokemonBattle.find(params[:id]))
				render 'show'
			end
		end

		def surrender
			action_type = params[:commit].downcase
			pokemon_battle = PokemonBattle.find(params[:id])
			@pokemon_battle_log = PokemonBattleLog.new()
			@pokemon_battle_log.pokemon_battle = pokemon_battle
			@pokemon_battle_log.turn = params[:current_turn]
			@pokemon_battle_log.attacker = Pokemon.find(params[:attacker_id])
			@pokemon_battle_log.defender = Pokemon.find(params[:defender_id])
			@pokemon_battle_log.action_type = action_type
			if @pokemon_battle_log.valid?
				ActiveRecord::Base.transaction do
					pokemon_battle.update(state: 'finish', current_turn: params[:current_turn].to_i + 1)
					@pokemon_battle_log.save
				end
				redirect_to pokemon_battle
			else
				decorator = PokemonBattlesDecorator.new(self)
				@decorated_pokemon_battle = decorator.decorate_for_show(PokemonBattle.find(params[:id]))
				render 'show'
			end
		end
end
