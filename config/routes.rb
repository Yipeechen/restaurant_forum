Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :restaurants, only: [:index, :show]
  root "restaurants#index"

  namespace :admin do
    resources :restaurants
    resources :categories 
    root "restaurants#index"
  end
end
