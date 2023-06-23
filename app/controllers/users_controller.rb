class UsersController < ApplicationController
  def userhome
    @reviews = Review.where(user_id: [current_user.id, *current_user.following.ids])
                     .order(created_at: :desc)
  end

  def show
    @user = User.find(params[:id])
    @reviews = @user.reviews.order(created_at: :desc)
  end

  def edit
  end

  def movielist
    @user = current_user
    @movies = @user.movie_lists.map(&:movie_details)
  end

  def likes
    @user = current_user
    @reviews = @user.liked_reviews.order(created_at: :desc)
  end
end
