class BattleEngine	
	def initialize(pokemon_battle:, pokemon_skill:, action_type:)
		@pokemon_battle = pokemon_battle
		if (@pokemon_battle.current_turn.odd?)
			@pokemon_attacker = @pokemon_battle.pokemon1
			@pokemon_defender = @pokemon_battle.pokemon2
		else
			@pokemon_attacker = @pokemon_battle.pokemon2
			@pokemon_defender = @pokemon_battle.pokemon1
		end
		@action_type = action_type
		@pokemon_skill = pokemon_skill
		@attack_damage = (pokemon_skill.skill.present?) ? PokemonCalculator.calculate_damage(attacker: @pokemon_attacker, defender: @pokemon_defender, skill: @pokemon_skill.skill) : 0
		last_health_point = @pokemon_defender.current_health_point - @attack_damage
		@defender_last_health_point = (last_health_point < 0) ? 0 : last_health_point
		initialize_pokemon_battle_log
	end

	def valid?
		@pokemon_battle_log.valid?
	end

	def execute
		(@action_type == 'attack') ? attack : surrender
	end

	def pokemon_battle_log
		@pokemon_battle_log
	end

	private
		def attack
			ActiveRecord::Base.transaction do
				update_pokemon_battle!(attacker: @pokemon_attacker, defender: @pokemon_defender, defender_last_health_point: @defender_last_health_point)
				update_pokemon_defender!
				update_pokemon_skill!
				@pokemon_battle_log.save
			end
		end

		def surrender
			ActiveRecord::Base.transaction do
				update_pokemon_battle!(attacker: @pokemon_attacker, defender: @pokemon_defender)
				@pokemon_battle_log.save
			end
		end

		def update_pokemon_battle!(attacker:, defender:, defender_last_health_point: nil)			
			if defender_last_health_point.present?
				if defender_last_health_point == 0
					@pokemon_battle.update(state: 'finish', pokemon_winner: attacker, pokemon_loser: defender)
				else
					@pokemon_battle.update(current_turn: @pokemon_battle.current_turn + 1)
				end
			else
				@pokemon_battle.update(state: 'finish', pokemon_winner: defender, pokemon_loser: attacker)
			end
		end

		def update_pokemon_defender!
			@pokemon_defender.update(current_health_point: @defender_last_health_point)
		end

		def update_pokemon_skill!
			@pokemon_skill.update(current_pp: @pokemon_skill.current_pp - 1)
		end		

		def initialize_pokemon_battle_log
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