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
		action_type = params[:action_type].downcase
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

		def attack
			action_type = params[:action_type].downcase
			pokemon_battle = PokemonBattle.find(params[:id])
			pokemon_attacker = Pokemon.find(params[:attacker_id])
			pokemon_defender = Pokemon.find(params[:defender_id])

			if params[:pokemon_skill_id].empty?
				pokemon_skill = PokemonSkill.new
				attack_damage = 0
			else
				pokemon_skill = PokemonSkill.find(params[:pokemon_skill_id])
				attack_damage = PokemonCalculator.calculate_damage(attacker: pokemon_attacker, defender: pokemon_defender, skill: pokemon_skill.skill)
			end

			last_health_point = pokemon_defender.current_health_point - attack_damage
			defender_last_health_point = (last_health_point < 0) ? 0 : last_health_point

			@pokemon_battle_log = PokemonBattleLog.new(
				pokemon_battle: pokemon_battle,
				turn: pokemon_battle.current_turn,
				skill: pokemon_skill.skill,
				damage: attack_damage,
				attacker: pokemon_attacker,
				defender: pokemon_defender,
				attacker_current_health_point: pokemon_attacker.current_health_point,
				defender_current_health_point: defender_last_health_point,
				action_type: action_type
			)

			if @pokemon_battle_log.valid?
				ActiveRecord::Base.transaction do
					if defender_last_health_point == 0
						pokemon_battle.update(state: 'finish', pokemon_winner: pokemon_attacker, pokemon_loser: pokemon_defender)
					else
						pokemon_battle.update(current_turn: pokemon_battle.current_turn + 1)
					end
					pokemon_defender.update(current_health_point: defender_last_health_point)
					pokemon_skill.update(current_pp: pokemon_skill.current_pp - 1)
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
			action_type = params[:action_type].downcase
			pokemon_attacker = Pokemon.find(params[:attacker_id])
			pokemon_defender = Pokemon.find(params[:defender_id])
			pokemon_battle = PokemonBattle.find(params[:id])
			
			@pokemon_battle_log = PokemonBattleLog.new(
				pokemon_battle: pokemon_battle,
				damage: 0,
				turn: pokemon_battle.current_turn,
				attacker: pokemon_attacker,
				defender: pokemon_defender,
				attacker_current_health_point: pokemon_attacker.current_health_point,
				defender_current_health_point: pokemon_defender.current_health_point,
				action_type: action_type
			)

			if @pokemon_battle_log.valid?
				ActiveRecord::Base.transaction do
					pokemon_battle.update(state: 'finish', pokemon_winner: pokemon_defender, pokemon_loser: pokemon_attacker)
					@pokemon_battle_log.save
				end
				redirect_to pokemon_battles_path
			else
				decorator = PokemonBattlesDecorator.new(self)
				@decorated_pokemon_battle = decorator.decorate_for_show(PokemonBattle.find(params[:id]))
				render 'show'
			end
		end
end
