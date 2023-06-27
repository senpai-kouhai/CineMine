class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review

  def create
    @comment = @review.comments.new(comment_params)
    @comment.user_id = current_user.id
    if @comment.save
      redirect_to movie_review_path(@review.movie, @review)
    else
      flash.now[:error] = 'コメントの投稿に失敗しました。'
      redirect_to movie_review_path(@review.movie, @review)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.user_id == current_user.id || current_user.admin?
      @comment.destroy
      redirect_to movie_review_path(@review.movie, @review)
    else
      flash.now[:error] = 'コメントの削除に失敗しました。'
      redirect_to movie_review_path(@review.movie, @review)
    end
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end
end