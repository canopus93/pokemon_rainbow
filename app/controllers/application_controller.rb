class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  	@top_ten_pokemon_winner = PokemonRainbowStatistic.top_ten_pokemon_winner
  	@top_ten_pokemon_loser = PokemonRainbowStatistic.top_ten_pokemon_loser
  	@top_ten_pokemon_surrender = PokemonRainbowStatistic.top_ten_pokemon_surrender
  end
end