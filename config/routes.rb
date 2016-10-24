Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  resources :pokedexes
  resources :pokemons do
    get :new_details, on: :new
    post :add_skill
    post '/remove_skill/:pokemon_skill_id', to: 'pokemons#remove_skill', as: 'remove_skill'
  end
  resources :skills
  resources :pokemon_battles, only: [:index, :show, :new, :create] do
    get :auto_battle
    post :action
    resources :pokemon_battle_logs, only: :index
  end
end
