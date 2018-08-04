Rails.application.routes.draw do
  # 實做新的 controller 去處理 callback
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  
  resources :restaurants, only: [:index, :show] do
    resources :comments, only: [:create, :destroy]

    collection do
      get :feeds

      get :ranking
    end

    member do
      get :dashboard
      
      post :favorite
      post :unfavorite
      
      post :like
      post :unlike
    end
  end
  
  resources :users, only: [:index, :show, :edit, :update] do
    member do
      get :friend_list
    end
  end
  
  resources :followships, only: [:create, :destroy]
  resources :friendships, only: [:create, :destroy]  do
    member do
      post :confirm
      delete :reject
    end
  end

  resources :categories, only: :show
  root "restaurants#index"

  namespace :admin do
    resources :restaurants
    resources :categories 
    root "restaurants#index"
  end
end
