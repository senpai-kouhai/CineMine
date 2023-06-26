Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root 'homes#top'

  resources :movies, only: [:index, :show] do
    resources :reviews, only: [:create, :show, :edit, :destroy, :update] do
      resources :likes, only: [:create, :destroy], module: :reviews
      resources :comments, only: [:create, :destroy, :edit]
    end
    member do
      post 'add_to_movielist'
      delete 'remove_from_movielist'
    end
    collection do
      get 'search'
    end
  end

  resources :reviews, only: [:index]

  resources :users, only: [:show, :edit,:update] do
    collection do
      get 'userhome'
      get 'movielist'
      get 'likes'
    end
  end

  get 'homes/top'
  get 'homes/about'

  resources :relationships, only: [:create, :destroy]
end