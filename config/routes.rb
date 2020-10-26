Rails.application.routes.draw do
  devise_for :users
  root to:  'books#index'
  resources :users, only: [:show, :edit, :update]
  resources :books do
    resources :posts, only: [:new, :create, :show, :edit, :update, :destroy]
  end
  resources :tags, only: :index
end
