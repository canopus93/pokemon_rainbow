class PokemonBattle < ApplicationRecord
	extend Enumerize

	ONGOING_STATE = 'ongoing'.freeze
	FINISH_STATE = 'finish'.freeze
	STATE_LIST = [ ONGOING_STATE, FINISH_STATE ]

	AUTO_BATTLE_TYPE = 'auto'.freeze
	MANUAL_BATTLE_TYPE = 'manual'.freeze
	VERSUS_AI_BATTLE_TYPE = 'versus ai'.freeze
	BATTLE_TYPE_LIST = [ AUTO_BATTLE_TYPE, MANUAL_BATTLE_TYPE, VERSUS_AI_BATTLE_TYPE ]
	
	belongs_to :pokemon1, class_name: 'Pokemon',
												foreign_key: 'pokemon1_id'
	belongs_to :pokemon2, class_name: 'Pokemon',
												foreign_key: 'pokemon2_id'
	belongs_to :pokemon_winner, class_name: 'Pokemon',
												foreign_key: 'pokemon_winner_id',
												optional: true
	belongs_to :pokemon_loser, class_name: 'Pokemon',
												foreign_key: 'pokemon_loser_id',
												optional: true
	has_many :pokemon_battle_logs

	enumerize :state, in: STATE_LIST
	enumerize :battle_type, in: BATTLE_TYPE_LIST

	validates :pokemon1_id, presence: true
	validates :pokemon2_id, presence: true
	validates :current_turn, presence: true,
										numericality: { greater_than: 0 }
	validates :state, presence: true,
					 					length: { maximum: 45 }
	validates :experience_gain, numericality: { only_integer: true }, if: :experience_gain_present?
	validates :pokemon1_max_health_point, presence: true,
										numericality: { greater_than: 0 }
	validates :pokemon2_max_health_point, presence: true,
										numericality: { greater_than: 0 }
	validates :battle_type, presence: true,
					 					length: { maximum: 45 }

	validate :pokemon1_and_pokemon2_must_not_same, if: :pokemon_1_and_pokemon_2_same?, on: :create
	validate :pokemon_still_on_batlle, unless: :pokemon_1_and_pokemon_2_same?, on: :create
	validate :pokemon_must_not_fainted, on: :create

	def pokemon1_and_pokemon2_must_not_same		
		errors.add(:pokemon2, "must not be same as Pokemon1")
	end

	def pokemon_still_on_batlle
		pokemon_id_with_ongoing_battle = PokemonBattle.where(state: ONGOING_STATE)
																		 							.pluck(:pokemon1_id, :pokemon2_id)
																		 							.flatten
																		 							.uniq
		
		errors.add(:pokemon1, "still on battle") if pokemon_id_with_ongoing_battle.include?(pokemon1_id)		
		errors.add(:pokemon2, "still on battle") if pokemon_id_with_ongoing_battle.include?(pokemon2_id)
	end

	def pokemon_1_and_pokemon_2_same?
		pokemon1_id == pokemon2_id
	end

	def pokemon_must_not_fainted
		if pokemon1_id.present? && pokemon2_id.present?
			errors.add(:pokemon1, "must not fainted") if pokemon1.current_health_point == 0
			errors.add(:pokemon2, "must not fainted") if pokemon2.current_health_point == 0
		end
	end

	def experience_gain_present?
		experience_gain.present?
	end
end