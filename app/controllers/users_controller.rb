# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %w[dashboard]

  def dashboard
    @user = current_user
    @my_games = Game.games_for(@user)
                    .paginate(page: params[:page])
                    .order('updated_at DESC')
  end
end
