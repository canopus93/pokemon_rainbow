class PokemonBattleLogsController < ApplicationController
	def index
		decorator = PokemonBattleLogsDecorator.new(self)
		@decorated_pokemon_battle_logs = decorator.decorate_for_index(PokemonBattleLog.where(pokemon_battle_id: params[:pokemon_battle_id]).paginate(page: params[:page], per_page: 10).order(id: :ASC))
		@pagination_pokemon_battle_logs = PokemonBattleLog.where(pokemon_battle_id: params[:pokemon_battle_id]).paginate(page: params[:page], per_page: 10).order(id: :ASC)
	end
end
