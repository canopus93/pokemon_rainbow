class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def index
  	top_ten_pokemon_winner = execute_sql("")
  end

  private

  def execute_sql(sql)
  	results = ActiveRecord::Base.connection.execute(sql)
  	results
  end
end
