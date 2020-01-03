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

    it 'should populate a game when first user joins' do
      user1 = create(:user1)
      sign_in(user1)
      post :create, params: { game: { name: 'Test' }, join: 'white' }
      game = user1.games.last
      expect(game.reload.pieces.length).to be 32
      sign_out(user1)

      user2 = create(:user2)
      sign_in(user2)
      put :update, params: { id: game.id, join: 'black' }
      expect(game.reload.pieces.length).to be 32
    end

    it 'should populate the game in order for Classic Chess' do
      user1 = create(:user1)
      sign_in(user1)
      post :create, params: { game: { name: 'Test' }, join: 'white', type: 'classic' }
      game = user1.games.last
      piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

      8.times do |x|
        expect(game.piece_at(x, 0).is_a?(piece_order[x])).to eq true
      end
    end

    it 'should populate the game randomly for Chess 960' do
      user1 = create(:user1)
      sign_in(user1)
      post :create,
           params: { game: { name: 'Test' },
                     join: 'white',
                     type: '960' }

      game = user1.games.last
      piece_order = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]

      all_match = true
      8.times do |x|
        all_match &= game.piece_at(x, 0).is_a?(piece_order[x])
      end

      expect(all_match).to eq false
    end
  end
end
