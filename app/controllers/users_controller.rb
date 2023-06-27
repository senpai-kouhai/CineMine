class UsersController < ApplicationController
  before_action :authenticate_user!

  def userhome
    @reviews = Review.where(user_id: [current_user.id, *current_user.following.ids])
                     .order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.order(created_at: :desc)
  end

  def edit
    @user = User.find(params[:id])
  end

  def movielist
    @user = current_user
    @movies = @user.movie_lists.map(&:movie_details)
  end

  def likes
    @user = current_user
    @reviews = @user.liked_reviews.order(created_at: :desc)
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit
    end
  end

  def search
    @users = User.where('username LIKE ?', "%#{params[:search]}%")
    @users = @users.where.not(id: current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :introduction, :profile_image)
  end
end
