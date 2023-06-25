class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def create
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params)
    @review.user = current_user  # ここで、現在のユーザーをレビューの作成者として設定します。
    if @review.save
      redirect_to @movie, notice: 'レビューを投稿しました。'
    else
      flash.now[:error] = 'レビューの投稿に失敗しました。'
      Rails.logger.info @review.errors.full_messages  # レビューのエラーメッセージをログに出力
      render 'movies/show'
    end
  end

  def show
    @review = Review.includes(:movie).find(params[:id])
    @comment = Comment.new
  end

    def index
      if params[:search].blank?
        @reviews = Review.all
      else
        @reviews = Review.search(params[:search])
      end
    end

  private

    def review_params
      params.require(:review).permit(:story_rating, :story_comment, :cast_rating, :cast_comment, :music_rating, :music_comment, :direction_rating, :direction_comment)
    end
end