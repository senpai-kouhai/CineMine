Rails.application.routes.draw do
  get 'reviews/show'
  get 'movies/index'
  get 'movies/show'
  get 'users/userhome'
  get 'users/show'
  get 'users/edit'
  get 'users/movielist'
  get 'homes/top'
  get 'homes/about'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  root 'homes#top'
end
