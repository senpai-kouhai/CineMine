class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :set_comment, only: [:destroy]

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.review_id = @review.id

    if @comment.save
      flash[:notice] = 'コメントが投稿されました。'
    else
      flash[:error] = 'コメントの投稿に失敗しました。'
    end

    redirect_to_review
  end

  def destroy
    if @comment.user_id == current_user.id || current_user.admin?
      @comment.destroy
      flash[:notice] = 'コメントが削除されました。'
    else
      flash[:error] = 'コメントの削除に失敗しました。'
    end

    redirect_to_review
  end

  private

  def set_review
    @review = Review.find(params[:review_id])
  end

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:comment)
  end

  def redirect_to_review
    redirect_to movie_review_path(@review.movie, @review)
  end
end
