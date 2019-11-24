# frozen_string_literal: true

require 'rails_helper'

RSpec.describe GamesController, type: :controller do
  context 'games#index action' do
    it 'should display index' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  context 'games#show action' do
    it 'should display show if game exists' do
      game = create(:game)
      get :show, params: { id: game.id }
      expect(response).to have_http_status(:success)
    end
  end

  context 'games#new action' do
    it 'should require users to be signed in' do
      get :new
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully render new view' do
      sign_in create(:user1)
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  context 'games#create action' do
    it 'should require users to be logged in' do
      post :create, params: { game: { name: 'Test' } }
      expect(response).to redirect_to new_user_session_path
    end

    it 'should successfully create a game' do
      user = create(:user1)
      sign_in(user)
      expect do
        post :create, params: { game: { name: 'Test' } }
      end.to change { user.games.count }.from(0).to(1)
    end

    it 'should populate a game when second user joins' do
      user1 = create(:user1)
      sign_in(user1)
      post :create, params: { game: { name: 'Test' }, join: 'white' }
      game = user1.games.last
      expect(game.reload.pieces.length).to be 0
      sign_out(user1)

      user2 = create(:user2)
      sign_in(user2)
      put :update, params: { id: game.id, join: 'black' }
      expect(game.reload.pieces.length).to be 32
    end
  end
end
