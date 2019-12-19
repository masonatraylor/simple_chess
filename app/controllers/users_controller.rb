class UsersController < ApplicationController
  before_action :authenticate_user!, only: %w[dashboard]

  def dashboard
    @user = current_user
    @games = Game.games_for(@user)
    
  end
end
