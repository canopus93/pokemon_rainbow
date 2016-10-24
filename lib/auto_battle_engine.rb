class AutoBattleEngine
	def initialize(pokemon_battle:)
		@pokemon_battle = pokemon_battle
	end

	def execute
		battle_engine = BattleEngine.new(@pokemon_battle)

		ActiveRecord::Base.transaction do
			while @pokemon_battle.state == PokemonBattle::ONGOING_STATE
				pokemon = (@pokemon_battle.current_turn.odd?) ? @pokemon_battle.pokemon1 : @pokemon_battle.pokemon2

				if has_available_skills?(pokemon)
					action_type = PokemonBattleLog::ATTACK_ACTION
					pokemon_skill = get_best_skill(pokemon)
				else
					action_type = PokemonBattleLog::SURRENDER_ACTION
					pokemon_skill = PokemonSkill.new
				end

				if battle_engine.valid_next_turn?(pokemon_skill: pokemon_skill, action_type: action_type)
					battle_engine.next_turn!(pokemon_skill)
					battle_engine.save!
				end
			end
		end
	end

	private

	def has_available_skills?(pokemon)
		skills = pokemon.pokemon_skills.where('current_pp > 0')
		skills.present?
	end

	def get_best_skill(pokemon)
		available_skills = pokemon.pokemon_skills
															.joins(:skill)
															.where('current_pp > 0')
															.order('skills.power DESC')
		available_skills.first
	end
end