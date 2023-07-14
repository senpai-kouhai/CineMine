class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update]
  before_action :ensure_admin, only: :destroy

  def userhome
    @reviews = Review.where(user_id: [current_user.id, *current_user.following.ids])
                     .order(created_at: :desc)
  end

  def show
    @reviews = @user.reviews.order(created_at: :desc)
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

  def destroy
    if @user.destroy
      redirect_to root_path, notice: 'ユーザーは正常に削除されました。'
    else
      redirect_to root_path, alert: 'ユーザーの削除に失敗しました。'
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def authorize_user
    unless @user == current_user || current_user.admin?
      flash[:alert] = "あなたにはこの操作を行う権限がありません。"
      redirect_to root_path
    end
  end

  def user_params
    params.require(:user).permit(:username, :email, :introduction, :profile_image)
  end

  def ensure_admin
    unless current_user.admin?
      redirect_to root_path, alert: '管理者権限がありません。'
    end
  end
end
