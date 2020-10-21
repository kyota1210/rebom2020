Rails.application.routes.draw do
  devise_for :users
  root to:  'books#index'
  resources :books, only: [:index, :new, :create, :show, :edit, :update] do
    resources :posts, only: [:new, :create, :show]
  end
  resources :users, only: [:show, :edit, :update]
end
