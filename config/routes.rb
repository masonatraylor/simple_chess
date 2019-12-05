Rails.application.routes.draw do
  root 'games#index'
  devise_for :users
  resources :games, only: %i[new create update show index]
  resources :pieces, only: %i[update]
  get '/pieces/:id/highlight_moves.js', to: 'pieces#highlight_moves'
end
