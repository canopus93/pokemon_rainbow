Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  get '/pokemons/new/details', to: 'pokemons#new_details'
  # post '/pokemons/new/details', to: 'pokemons#new_details'

  resources :pokedexes
  resources :pokemons
  resources :skills
end
