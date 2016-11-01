class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_breadcrumb "Home", :root_path

  def index
  	@top_ten_pokemon_winner = PokemonRainbowStatistic.top_ten_pokemon_winner
  	@top_ten_pokemon_loser = PokemonRainbowStatistic.top_ten_pokemon_loser
  	@top_ten_pokemon_surrender = PokemonRainbowStatistic.top_ten_pokemon_surrender
  	@top_ten_pokemon_win_rate = PokemonRainbowStatistic.top_ten_pokemon_win_rate
  	@top_ten_pokemon_lose_rate = PokemonRainbowStatistic.top_ten_pokemon_lose_rate
  	@top_ten_pokemon_used_in_battle = PokemonRainbowStatistic.top_ten_pokemon_used_in_battle
  	@top_ten_skill_used_in_battle = PokemonRainbowStatistic.top_ten_skill_used_in_battle
  	@top_ten_pokemon_with_biggest_total_damage = PokemonRainbowStatistic.top_ten_pokemon_with_biggest_total_damage
  	@top_ten_pokedex_average_level = PokemonRainbowStatistic.top_ten_pokedex_average_level
    @top_ten_pokemon_win_streak = PokemonRainbowStatistic.top_ten_pokemon_win_streak
  end
end