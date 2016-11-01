class PokemonsController < ApplicationController
	add_breadcrumb "Pokemons", :pokemons_path

	def index
		decorator = PokemonsDecorator.new(self)
		@decorated_pokemons = decorator.decorate_for_index(Pokemon.paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_pokemons = Pokemon.paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end

	def show
		decorator = PokemonsDecorator.new(self)
		@decorated_pokemon = decorator.decorate_for_show(Pokemon.find(params[:id]))
		@pokemon_skill = PokemonSkill.new
		add_breadcrumb @decorated_pokemon.name
	end

	def new
		@pokemon = Pokemon.new
		add_breadcrumb 'New'
	end

	def new_details
		pokedex = Pokedex.find(params[:q])
		@pokemon = Pokemon.new(pokedex: pokedex, name: pokedex.name, level: 1, current_health_point: pokedex.base_health_point, max_health_point: pokedex.base_health_point, attack: pokedex.base_attack, defence: pokedex.base_defence, speed: pokedex.base_speed, current_experience: 0)
		add_breadcrumb 'New', :new_pokemon_path
		add_breadcrumb 'Details'
	end

	def add_skill
		pokemon = Pokemon.find(params[:pokemon_id])
		skill = Skill.find_by(id: params[:pokemon_skill][:skill_id])
		@pokemon_skill = PokemonSkill.new(pokemon: pokemon, skill: skill, current_pp: params[:pokemon_skill][:current_pp])

		decorator = PokemonsDecorator.new(self)
		@decorated_pokemon = decorator.decorate_for_show(pokemon)

		if @pokemon_skill.save
			redirect_to pokemon
		else
			render 'show'
		end
	end

	def heal
		pokemon = Pokemon.find(params[:pokemon_id])

		ActiveRecord::Base.transaction do
			pokemon.current_health_point = pokemon.max_health_point
			pokemon.pokemon_skills.each do |pokemon_skill|
				pokemon_skill.current_pp = pokemon_skill.skill.max_pp
				pokemon_skill.save
			end
			pokemon.save
		end

		redirect_to pokemon
	end

	def heal_all
		pokemon_id_with_ongoing_battle = PokemonBattle.where(state: PokemonBattle::ONGOING_STATE)
																			 							.pluck(:pokemon1_id, :pokemon2_id)
																			 							.flatten
																			 							.uniq

		pokemons = Pokemon.where.not(id: pokemon_id_with_ongoing_battle)
		pokemon_skills = PokemonSkill.includes(:skill).where.not(pokemon_id: pokemon_id_with_ongoing_battle)
		ActiveRecord::Base.transaction do
			pokemons.update_all('current_health_point = max_health_point')
			pokemon_skills.each do |pokemon_skill|
				pokemon_skill.current_pp = pokemon_skill.skill.max_pp
			end
			pokemon_skills.each(&:save)
		end
		redirect_to pokemons_path
	end

	def edit
		@pokemon = Pokemon.find(params[:id])
		add_breadcrumb @pokemon.name, @pokemon
		add_breadcrumb 'Edit'
	end

	def create
		@pokemon = Pokemon.new(pokemon_params)

		if @pokemon.save
			redirect_to @pokemon
		else
			render 'new_details'
		end
	end

	def update
		@pokemon = Pokemon.find(params[:id])

		if @pokemon.update(pokemon_params)
			redirect_to @pokemon
		else
			render 'edit'
		end
	end

	def destroy
		@pokemon = Pokemon.find(params[:id])
		@pokemon.destroy

		redirect_to pokemons_path
	end

	def remove_skill
		PokemonSkill.find(params[:pokemon_skill_id])
								.destroy

		redirect_to pokemon_path(params[:pokemon_id])
	end

	private
		def pokemon_params
			params.require(:pokemon).permit(:pokedex_id, :name, :level, :max_health_point, :current_health_point, :attack, :defence, :speed, :current_experience)
		end
end
