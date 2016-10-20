class BattleEngine
	def initialize(pokemon_battle:, pokemon_skill:, action_type:)
		@pokemon_battle = pokemon_battle
		@pokemon_attacker = (@pokemon_battle.current_turn.odd?) ? @pokemon_battle.pokemon1 : @pokemon_battle.pokemon2
		@pokemon_defender = (@pokemon_battle.current_turn.odd?) ? @pokemon_battle.pokemon2 : @pokemon_battle.pokemon1
		@action_type = action_type
		@pokemon_skill = pokemon_skill
		@attack_damage = (pokemon_skill.skill.present?) ? PokemonCalculator.calculate_damage(attacker: @pokemon_attacker, defender: @pokemon_defender, skill: @pokemon_skill.skill) : 0
		last_health_point = @pokemon_defender.current_health_point - @attack_damage
		@defender_last_health_point = (last_health_point < 0) ? 0 : last_health_point
	end

	def execute_action
		generate_pokemon_battle_log
		if @pokemon_battle_log.valid?
			(@action_type == 'attack') ? attack : surrender
			true
		else
			@pokemon_battle_log
		end
	end

	private
		def attack
			ActiveRecord::Base.transaction do
				if @defender_last_health_point == 0
					@pokemon_battle.update(state: 'finish', pokemon_winner: @pokemon_attacker, pokemon_loser: @pokemon_defender)
				else
					@pokemon_battle.update(current_turn: @pokemon_battle.current_turn + 1)
				end
				@pokemon_defender.update(current_health_point: @defender_last_health_point)
				@pokemon_skill.update(current_pp: @pokemon_skill.current_pp - 1)
				@pokemon_battle_log.save
			end
		end

		def surrender
			ActiveRecord::Base.transaction do
				@pokemon_battle.update(state: 'finish', pokemon_winner: @pokemon_defender, pokemon_loser: @pokemon_attacker)
				@pokemon_battle_log.save
			end
		end

		def generate_pokemon_battle_log
			@pokemon_battle_log = PokemonBattleLog.new(
				pokemon_battle: @pokemon_battle,
				turn: @pokemon_battle.current_turn,
				skill: @pokemon_skill.skill,
				damage: @attack_damage,
				attacker: @pokemon_attacker,
				defender: @pokemon_defender,
				attacker_current_health_point: @pokemon_attacker.current_health_point,
				defender_current_health_point: @defender_last_health_point,
				action_type: @action_type
			)
		end
end