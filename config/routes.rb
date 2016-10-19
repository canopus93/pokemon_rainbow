Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  get '/pokemons/new/details', to: 'pokemons#new_details'
  post '/pokemons/:id/add_skill', to: 'pokemons#add_skill', as: 'pokemons_add_skill'
  post '/pokemons/:id/remove_skill/:pokemon_skill_id', to: 'pokemons#remove_skill', as: 'pokemons_remove_skill'

  resources :pokedexes
  resources :pokemons
  resources :skills
  resources :pokemon_battles
end
