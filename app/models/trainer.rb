class Trainer < ApplicationRecord
	has_many :trainer_pokemons, dependent: :destroy
	has_many :pokemon, through: :trainer_pokemons

	validates :name, presence: true,
						length: { maximum: 45 }
	validates :email, presence: true,
					  length: { maximum: 45 },
					  uniqueness: { case_sensitive: false },
					  format: { :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/ }
end
