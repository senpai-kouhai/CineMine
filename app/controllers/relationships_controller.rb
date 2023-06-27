class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:followed_id])

    if @user == current_user
      flash[:alert] = "自分自身をフォローすることはできません。"
      redirect_to @user
    else
      current_user.follow(@user)
      respond_to do |format|
        format.html { redirect_to @user }
        format.js
      end
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
