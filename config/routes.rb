Rails.application.routes.draw do
  devise_for :users
  root to:  'books#index'
  resources :books, only: [:index, :new, :create, :show] do
    resources :posts, only: [:new, :create]
  end
  resources :users, only: [:show, :edit, :update]
end
