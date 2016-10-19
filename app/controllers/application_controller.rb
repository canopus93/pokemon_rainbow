class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  	# (0..100).each do |x|
  	# 	pokedex = Pokedex.new(
  	# 		name: "Pokedex #{x}",
  	# 		base_health_point: rand(100)+1,
  	# 		base_attack: rand(100) +1,
  	# 		base_defence: rand(100) +1,
  	# 		base_speed: rand(100) +1,
  	# 		element_type: Pokedex::ELEMENT_TYPE_LIST.sample
  	# 	)
  	# 	pokedex.save!
  	# end

  	# (0..100).each do |x|
  	# 	pokemon = Pokemon.new(
  	# 		name: "Pokemon #{x}",
  	# 		level: 1,
  	# 		pokedex: Pokedex.find(x+1),
  	# 		current_health_point: 100,
  	# 		max_health_point: 100,
  	# 		attack: rand(100) +1,
  	# 		defence: rand(100) +1,
  	# 		speed: rand(100) +1,
  	# 		current_experience: 0
  	# 	)
  	# 	pokemon.save!
  	# end

  	# (0..100).each do |x|
  	# 	skill = Skill.new(
  	# 		name: "Skill #{x}",
  	# 		power: rand(100)+1,
  	# 		max_pp: rand(100)+1,
  	# 		element_type: Pokedex::ELEMENT_TYPE_LIST.sample
  	# 	)
  	# 	skill.save!
  	# end
  end
end
