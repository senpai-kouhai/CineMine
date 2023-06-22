Rails.application.routes.draw do
  devise_for :users
  root 'homes#top'

  resources :movies, only: [:index, :show] do
    resources :reviews, only: [:create, :show] do
      resources :likes, only: [:create, :destroy], module: :reviews
    end
    collection do
      get 'search'
    end
  end

  resources :users, only: [:show, :edit] do
    collection do
      get 'userhome'
      get 'movielist'
    end
  end

  get 'homes/top'
  get 'homes/about'

  resources :relationships, only: [:create, :destroy]
end