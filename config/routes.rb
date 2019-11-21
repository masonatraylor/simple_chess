Rails.application.routes.draw do
  root 'games#index'
  get 'games/index'
  devise_for :users
end
