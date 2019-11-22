Rails.application.routes.draw do
  root 'games#index'
  devise_for :users
  resources :games, only: %i[new create show index]
end
