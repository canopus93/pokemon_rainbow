class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  	top_ten_pokemon_winner = execute_sql("select p.name, count(p.id) from pokemons p inner join pokemon_battles pb on p.id = pb.pokemon_winner_id GROUP BY p.id ORDER BY count DESC LIMIT 10")
  end

  private

  def execute_sql(sql)
  	results = ActiveRecord::Base.connection.execute(sql)
  	results
  end
end
