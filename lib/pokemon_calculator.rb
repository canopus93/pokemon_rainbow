class PokemonCalculator
	DAMAGE_RATIO = {
		normal: {
			normal: 1,
			fighting: 1,
			flying: 1,
			poison: 1,
			ground: 1,
			rock: 0.5,
			bug: 1,
			ghost: 0,
			steel: 0.5,
			fire: 1,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 1,
			ice: 1,
			dragon: 1,
			dark: 1,
			fairy: 1
		},
		fighting: {
			normal: 2,
			fighting: 1,
			flying: 0.5,
			poison: 0.5,
			ground: 1,
			rock: 2,
			bug: 0.5,
			ghost: 0,
			steel: 2,
			fire: 1,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 0.5,
			ice: 2,
			dragon: 1,
			dark: 2,
			fairy: 0.5
		},
		flying: {
			normal: 1,
			fighting: 2,
			flying: 1,
			poison: 1,
			ground: 1,
			rock: 0.5,
			bug: 2,
			ghost: 1,
			steel: 0.5,
			fire: 1,
			water: 1,
			grass: 2,
			electric: 0.5,
			psychic: 1,
			ice: 1,
			dragon: 1,
			dark: 1,
			fairy: 1
		},
		poison: {
			normal: 1,
			fighting: 1,
			flying: 1,
			poison: 0.5,
			ground: 0.5,
			rock: 0.5,
			bug: 1,
			ghost: 0.5,
			steel: 0,
			fire: 1,
			water: 1,
			grass: 2,
			electric: 1,
			psychic: 1,
			ice: 1,
			dragon: 1,
			dark: 1,
			fairy: 2
		},
		ground: {
			normal: 1,
			fighting: 1,
			flying: 0,
			poison: 2,
			ground: 1,
			rock: 2,
			bug: 0.5,
			ghost: 1,
			steel: 2,
			fire: 2,
			water: 1,
			grass: 0.5,
			electric: 2,
			psychic: 1,
			ice: 1,
			dragon: 1,
			dark: 1,
			fairy: 1
		},
		rock: {
			normal: 1,
			fighting: 0.5,
			flying: 2,
			poison: 1,
			ground: 0.5,
			rock: 1,
			bug: 2,
			ghost: 1,
			steel: 0.5,
			fire: 2,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 1,
			ice: 2,
			dragon: 1,
			dark: 1,
			fairy: 1
		},
		bug: {
			normal: 1,
			fighting: 0.5,
			flying: 0.5,
			poison: 0.5,
			ground: 1,
			rock: 1,
			bug: 1,
			ghost: 0.5,
			steel: 0.5,
			fire: 0.5,
			water: 1,
			grass: 2,
			electric: 1,
			psychic: 2,
			ice: 1,
			dragon: 1,
			dark: 2,
			fairy: 0.5
		},
		ghost: {
			normal: 0,
			fighting: 1,
			flying: 1,
			poison: 1,
			ground: 1,
			rock: 1,
			bug: 1,
			ghost: 2,
			steel: 1,
			fire: 1,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 2,
			ice: 1,
			dragon: 1,
			dark: 0.5,
			fairy: 1
		},
		steel: {
			normal: 1,
			fighting: 1,
			flying: 1,
			poison: 1,
			ground: 1,
			rock: 2,
			bug: 1,
			ghost: 1,
			steel: 0.5,
			fire: 0.5,
			water: 0.5,
			grass: 1,
			electric: 0.5,
			psychic: 1,
			ice: 2,
			dragon: 1,
			dark: 1,
			fairy: 2
		},
		fire: {
			normal: 1,
			fighting: 1,
			flying: 1,
			poison: 1,
			ground: 1,
			rock: 0.5,
			bug: 2,
			ghost: 1,
			steel: 2,
			fire: 0.5,
			water: 0.5,
			grass: 2,
			electric: 1,
			psychic: 1,
			ice: 2,
			dragon: 0.5,
			dark: 1,
			fairy: 1
		},
		water: {
			normal: 1,
			fighting: 1,
			flying: 1,
			poison: 1,
			ground: 2,
			rock: 2,
			bug: 1,
			ghost: 1,
			steel: 1,
			fire: 2,
			water: 0.5,
			grass: 0.5,
			electric: 1,
			psychic: 1,
			ice: 1,
			dragon: 0.5,
			dark: 1,
			fairy: 1
		},
		grass: {
			normal: 1,
			fighting: 1,
			flying: 0.5,
			poison: 0.5,
			ground: 2,
			rock: 2,
			bug: 0.5,
			ghost: 1,
			steel: 0.5,
			fire: 0.5,
			water: 2,
			grass: 0.5,
			electric: 1,
			psychic: 1,
			ice: 1,
			dragon: 0.5,
			dark: 1,
			fairy: 1
		},
		electric: {
			normal: 1,
			fighting: 1,
			flying: 2,
			poison: 1,
			ground: 0,
			rock: 1,
			bug: 1,
			ghost: 1,
			steel: 1,
			fire: 1,
			water: 2,
			grass: 0.5,
			electric: 0.5,
			psychic: 1,
			ice: 1,
			dragon: 0.5,
			dark: 1,
			fairy: 1
		},
		psychic: {
			normal: 1,
			fighting: 2,
			flying: 1,
			poison: 2,
			ground: 1,
			rock: 1,
			bug: 1,
			ghost: 1,
			steel: 0.5,
			fire: 1,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 0.5,
			ice: 1,
			dragon: 1,
			dark: 0,
			fairy: 1
		},
		ice: {
			normal: 1,
			fighting: 1,
			flying: 2,
			poison: 1,
			ground: 2,
			rock: 1,
			bug: 1,
			ghost: 1,
			steel: 0.5,
			fire: 0.5,
			water: 0.5,
			grass: 2,
			electric: 1,
			psychic: 1,
			ice: 0.5,
			dragon: 2,
			dark: 1,
			fairy: 1
		},
		dragon: {
			normal: 1,
			fighting: 1,
			flying: 1,
			poison: 1,
			ground: 1,
			rock: 1,
			bug: 1,
			ghost: 1,
			steel: 0.5,
			fire: 1,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 1,
			ice: 1,
			dragon: 2,
			dark: 1,
			fairy: 0
		},
		dark: {
			normal: 1,
			fighting: 0.5,
			flying: 1,
			poison: 1,
			ground: 1,
			rock: 1,
			bug: 1,
			ghost: 2,
			steel: 1,
			fire: 1,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 2,
			ice: 1,
			dragon: 1,
			dark: 0.5,
			fairy: 0.5
		},
		fairy: {
			normal: 1,
			fighting: 2,
			flying: 1,
			poison: 0.5,
			ground: 1,
			rock: 1,
			bug: 1,
			ghost: 1,
			steel: 0.5,
			fire: 0.5,
			water: 1,
			grass: 1,
			electric: 1,
			psychic: 1,
			ice: 1,
			dragon: 2,
			dark: 2,
			fairy: 1
		}
	}

	ExtraStatsResult = Struct.new(
		:health_point,
		:attack,
		:defence,
		:speed
	)

	def self.calculate_damage(attacker:, defender:, skill:)
		stab = (attacker.pokedex.element_type == skill.element_type) ? 1.5 : 1
		damage_ratio = DAMAGE_RATIO[skill.element_type.to_sym][defender.pokedex.element_type.to_sym]
		random_number = rand(85..100).to_d

		result = ((((2 * attacker.level / 5 + 2) * attacker.attack * skill.power / defender.defence) / 50) + 2) * stab * damage_ratio * (random_number / 100)
		result.round
	end

	def self.calculate_experience(level:)
		rand(20..150) * level
	end

	def self.level_up?(level:, total_experience:)
		experience_limit = level * 200
		(total_experience >= experience_limit) ? true : false
	end

	def self.calculate_level_up_extra_stats
		result = ExtraStatsResult.new
		result.health_point = rand(10..20)
		result.attack = rand(1..5)
		result.defence = rand(1..5)
		result.speed = rand(1..5)
		result
	end
end