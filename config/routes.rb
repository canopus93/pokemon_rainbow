Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'application#index'

  resources :trainers do
    post :add_pokemon
    post '/remove_pokemon/:trainer_pokemon_id', to: 'trainers#remove_pokemon', as: 'remove_pokemon' 
  end
  resources :pokedexes
  resources :pokemons do
    get :new_details, on: :new
    post :add_skill
    get :heal
    post '/remove_skill/:pokemon_skill_id', to: 'pokemons#remove_skill', as: 'remove_skill'
    collection do
      get :heal_all
    end
  end
  
  resources :skills
  resources :pokemon_battles, only: [:index, :show, :new, :create] do
    get :auto_battle
    get :evolution_confirmation
    get :choose_skill
    post :submit_skill
    post :evolve
    post :action
    resources :pokemon_battle_logs, only: :index
  end
end
