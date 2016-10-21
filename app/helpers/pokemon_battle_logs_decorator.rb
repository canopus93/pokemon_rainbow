class PokemonBattleLogsDecorator
	include Rails.application.routes.url_helpers
	include ActionView::Helpers::UrlHelper

	PokemonBattleLogsDecoratorResult = Struct.new(
		:turn,
		:link_to_skill,
		:damage,
		:link_to_attacker,
		:attacker_current_hp,
		:link_to_defender,
		:defender_current_hp,
		:action_type
	)

	def initialize(context)
		@context = context
	end

	def decorate_for_index(pokemon_battle_logs)
		result = []

		pokemon_battle_logs.each do |pokemon_battle_log|
			result << generate_decorator_result(pokemon_battle_log: pokemon_battle_log)
		end
		result
	end

	private
		def generate_decorator_result(pokemon_battle_log:)
			pokemon_battle = pokemon_battle_log.pokemon_battle

			if pokemon_battle.pokemon1 == pokemon_battle_log.attacker
				attacker_max_hp = pokemon_battle.pokemon1_max_health_point
				defender_max_hp = pokemon_battle.pokemon2_max_health_point
			else
				attacker_max_hp = pokemon_battle.pokemon2_max_health_point
				defender_max_hp = pokemon_battle.pokemon1_max_health_point
			end

			result = PokemonBattleLogsDecoratorResult.new
			result.turn = pokemon_battle_log.turn
			result.link_to_skill = link_to_skill(skill: pokemon_battle_log.skill) if !pokemon_battle_log.skill.nil?
			result.damage = pokemon_battle_log.damage
			result.link_to_attacker = link_to_attacker(attacker: pokemon_battle_log.attacker)
			result.attacker_current_hp = "#{pokemon_battle_log.attacker_current_health_point} / #{attacker_max_hp}"
			result.link_to_defender = link_to_defender(defender: pokemon_battle_log.defender)
			result.defender_current_hp = "#{pokemon_battle_log.defender_current_health_point} / #{defender_max_hp}"
			result.action_type = pokemon_battle_log.action_type
			result
		end

		def link_to_skill(skill:)
			@context.helpers.link_to skill.name, skill_path(skill.id)
		end

		def link_to_attacker(attacker:)
			@context.helpers.link_to attacker.name, pokemon_path(attacker.id)
		end

		def link_to_defender(defender:)
			@context.helpers.link_to defender.name, pokemon_path(defender.id)
		end
end