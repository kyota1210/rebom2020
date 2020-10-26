Rails.application.routes.draw do
  get 'favorites/create'
  get 'favorites/destroy'
  devise_for :users
  root to:  'books#index'
  resources :users, only: [:show, :edit, :update]
  resources :books, shallow: true do
    resources :posts, only: [:new, :create, :show, :edit, :update, :destroy]
    resource :favorites, only: %i[create destroy]
    collection do
      get :favorites
    end
  end
  resources :tags, only: :index
end
