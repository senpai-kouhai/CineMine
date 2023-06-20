class UsersController < ApplicationController
  def userhome
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.order(created_at: :desc)
  end

  def edit
  end

  def movielist
  end
end
