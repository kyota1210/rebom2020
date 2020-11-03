Rails.application.routes.draw do
  devise_for :users
  root to:  'books#index'
  resources :users, only: [:show, :edit, :update]
  resources :books do
    resources :posts, only: [:new, :create, :show, :edit, :update, :destroy]
    resource :favorites, only: [:create, :destroy]
    collection do
      get :favorites
    end
  end
  resources :tags, only: :index
  resources :sales, only: [:new]
end
