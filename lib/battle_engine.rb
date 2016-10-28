class BattleEngine
	attr_accessor :pokemon_battle, :pokemons, :pokemon_skill, :pokemon_battle_log
	attr_reader :errors

	def initialize(pokemon_battle)
		@errors = {skill: '', action_type: ''}
		@pokemon_battle = pokemon_battle
		@pokemons = [@pokemon_battle.pokemon1, @pokemon_battle.pokemon2]
	end

	def valid_next_turn?(pokemon_skill:, action_type:)
		@action_type = action_type
		if @action_type == PokemonBattleLog::ATTACK_ACTION
			if pokemon_skill.skill.present?
				valid_attacker_pokemon = @pokemon_battle.current_turn.odd? ? @pokemon_battle.pokemon1 : @pokemon_battle.pokemon2
				if pokemon_skill.pokemon == valid_attacker_pokemon
					true
				else
					@errors[:skill] = 'Invalid Pokemon Skill'
					false
				end
			else
				@errors[:skill] = 'Skill Must Exist'
				false
			end
		elsif @action_type == PokemonBattleLog::SURRENDER_ACTION
			true
		else
			@errors[:action_type] = 'Invalid Action Type'
			false
		end
	end

	def next_turn!(pokemon_skill)
		if (@pokemon_battle.current_turn.odd?)
			@pokemon_attacker = @pokemon_battle.pokemon1
			@pokemon_defender = @pokemon_battle.pokemon2
		else
			@pokemon_attacker = @pokemon_battle.pokemon2
			@pokemon_defender = @pokemon_battle.pokemon1
		end
		@pokemon_skill = pokemon_skill
		@attack_damage = (@pokemon_skill.skill.present?) ? PokemonCalculator.calculate_damage(attacker: @pokemon_attacker, defender: @pokemon_defender, skill: @pokemon_skill.skill) : 0
		last_health_point = @pokemon_defender.current_health_point - @attack_damage
		@defender_last_health_point = (last_health_point < 0) ? 0 : last_health_point
		initialize_pokemon_battle_log

		(@action_type == PokemonBattleLog::ATTACK_ACTION) ? attack : surrender
	end

	def is_attack?
		@action_type == PokemonBattleLog::ATTACK_ACTION
	end

	def save!
		pokemon_battle.save!
		pokemons.each { |pokemon| pokemon.save! }
		pokemon_skill.save! if is_attack?
		pokemon_battle_log.save!
	end

	private

	def attack
		update_pokemon_battle!(attacker: @pokemon_attacker, defender: @pokemon_defender, defender_last_health_point: @defender_last_health_point)
		update_pokemon_defender!
		update_pokemon_skill!
	end

	def surrender
		update_pokemon_battle!(attacker: @pokemon_attacker, defender: @pokemon_defender)
	end

	def update_pokemon_battle!(attacker:, defender:, defender_last_health_point: nil)
		if defender_last_health_point.present?
			if defender_last_health_point == 0
				experience_gain = PokemonCalculator.calculate_experience(level: defender.level)

				update_pokemon_winner!(pokemon_winner: attacker, experience_gain: experience_gain)

				@pokemon_battle.state = PokemonBattle::FINISH_STATE
				@pokemon_battle.pokemon_winner = attacker
				@pokemon_battle.pokemon_loser = defender
				@pokemon_battle.experience_gain = experience_gain
			else
				@pokemon_battle.current_turn += 1
			end
		else
			experience_gain = PokemonCalculator.calculate_experience(level: attacker.level)

			update_pokemon_winner!(pokemon_winner: defender, experience_gain: experience_gain)
			
			@pokemon_battle.state = PokemonBattle::FINISH_STATE
			@pokemon_battle.pokemon_winner = defender
			@pokemon_battle.pokemon_loser = attacker
			@pokemon_battle.experience_gain = experience_gain
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
	end

	def update_pokemon_defender!
		@pokemon_defender.current_health_point = @defender_last_health_point
	end

	def update_pokemon_skill!
		@pokemon_skill.current_pp -= 1
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