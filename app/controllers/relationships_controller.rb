class RelationshipsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [:create, :destroy]
  before_action :prevent_self_follow, only: :create

  def create
    current_user.follow(@user)
    respond_to_user
  end

  def destroy
    current_user.unfollow(@user)
    respond_to_user
  end

  private

  def set_user
    if params[:followed_id].present?
      @user = User.find(params[:followed_id]) #ユーザーを followed_id の値に基づいてデータベースから取得
    else
      @user = Relationship.find(params[:id]).followed #Relationship から params[:id] の値に基づいてレコードをデータベースから取得
    end
  end

  def prevent_self_follow
    if @user == current_user
      flash[:alert] = "自分自身をフォローすることはできません。"
      redirect_to @user
    end
  end

  def respond_to_user
    respond_to do |format| #レスポンスを設定
      format.html { redirect_to @user } #リクエストがHTMLフォーマットである場合
      format.js #リクエストがJavaScriptフォーマットである場合
    end
  end
end
