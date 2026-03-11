Rails.application.routes.draw do
  # Création Users avec devise pour l'authentification
  devise_for :users
  root to: "pages#home"

  # Utilisation de authenticate user pour ne pas creer de doublon de users/devise
  # authenticate user pour ne pas avoir la possibilité de recupérer/changer les id d'autres users dans l'url
  authenticate :user do
    resources :user_babies, only: [:new, :create]
  end

  resources :user_babies, only: [:destroy, :update, :edit, :show]
  resources :emergencies, only: [:index]
  root to: "pages#home"
  get "up" => "rails/health#show", as: :rails_health_check
  resources :user_babies, only: [:destroy, :update, :edit, :show] do
    # On niche les chats sous les bébés pour savoir qui on analyse
    resources :chats, only: [:new, :create]
  end


  resources :chats, only: [:index, :show, :new, :create, :destroy] do
    resources :messages, only: [:create]
    # Le résultat est souvent unique par chat
    resources :results, only: [:create, :show]
    # Route personnalisée pour déclencher la génération de la roadmap
    member do
      post :generate_roadmap
    end
  end
  get "up" => "rails/health#show", as: :rails_health_check
end
