Rails.application.routes.draw do
  devise_for :users
  root to:  'books#index'
  resources :books do
    resources :posts, only: [:new, :create, :show, :edit, :update]
  end
  resources :users, only: [:show, :edit, :update]
end
