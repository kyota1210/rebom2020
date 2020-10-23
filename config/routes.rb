Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }
  root to:  'books#index'
  resources :books do
    resources :posts, only: [:new, :create, :show, :edit, :update, :destroy]
  end
  resources :users, only: [:show, :edit, :update]
end
