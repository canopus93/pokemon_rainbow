class BattleEngine	
	attr_reader :pokemon_battle_log

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
		ActiveRecord::Base.transaction do
			(@action_type == 'attack') ? attack : surrender
		end
	end

	private

	def attack
		update_pokemon_battle!(attacker: @pokemon_attacker, defender: @pokemon_defender, defender_last_health_point: @defender_last_health_point)
		update_pokemon_defender!
		update_pokemon_skill!
		@pokemon_battle_log.save
	end

	def surrender
		update_pokemon_battle!(attacker: @pokemon_attacker, defender: @pokemon_defender)
		@pokemon_battle_log.save
	end

	def update_pokemon_battle!(attacker:, defender:, defender_last_health_point: nil)
		if defender_last_health_point.present?
			if defender_last_health_point == 0
				experience_gain = PokemonCalculator.calculate_experience(level: defender.level)

				update_pokemon_winner!(pokemon_winner: attacker, experience_gain: experience_gain)
				@pokemon_battle.update(
					state: 'finish', 
					pokemon_winner: attacker, 
					pokemon_loser: defender, 
					experience_gain: experience_gain
				)
			else
				@pokemon_battle.update(current_turn: @pokemon_battle.current_turn + 1)
			end
		else
			experience_gain = PokemonCalculator.calculate_experience(level: attacker.level)

			update_pokemon_winner!(pokemon_winner: defender, experience_gain: experience_gain)
			@pokemon_battle.update(
				state: 'finish', 
				pokemon_winner: defender, 
				pokemon_loser: attacker,
				experience_gain: experience_gain
			)
		end		
	end

	def update_pokemon_winner!(pokemon_winner:, experience_gain:)
		pokemon_winner.current_experience += experience_gain

		while PokemonCalculator.level_up?(level: pokemon_winner.level, total_experience: pokemon_winner.current_experience)
			extra_stats = PokemonCalculator.calculate_level_up_extra_stats
			pokemon_winner.max_health_point += extra_stats.health_point
			pokemon_winner.attack += extra_stats.attack
			pokemon_winner.defence += extra_stats.defence
			pokemon_winner.speed += extra_stats.speed
			pokemon_winner.level += 1
		end

		pokemon_winner.save
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