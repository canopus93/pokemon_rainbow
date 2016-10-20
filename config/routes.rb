Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  get '/pokemons/new/details', to: 'pokemons#new_details'
  post '/pokemons/:id/add_skill', to: 'pokemons#add_skill', as: 'pokemons_add_skill'
  post '/pokemons/:id/remove_skill/:pokemon_skill_id', to: 'pokemons#remove_skill', as: 'pokemons_remove_skill'
  post '/pokemon_battles/:id/action', to: 'pokemon_battles#action', as: 'pokemons_battle_action'

  resources :pokedexes
  resources :pokemons
  resources :skills
  resources :pokemon_battles do
    resources :pokemon_battle_logs, only: :index
  end
end
