class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]

  def create
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params)
    @review.user = current_user
    if @review.save
      redirect_to @movie, notice: 'レビューを投稿しました。'
    else
      flash.now[:error] = 'レビューの投稿に失敗しました。'
      Rails.logger.info @review.errors.full_messages
      @reviews = @movie.reviews.where.not(id: nil)
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

  def edit
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(review_params)
      redirect_to movie_review_path(@review.movie, @review), notice: 'レビューを更新しました。'
    else
      flash.now[:error] = 'レビューの更新に失敗しました。'
      Rails.logger.info @review.errors.full_messages
      render :edit
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @review.destroy
    redirect_to movies_path, notice: 'レビューを削除しました。'
  end

  private

    def review_params
      params.require(:review).permit(:story_rating, :story_comment, :cast_rating, :cast_comment, :music_rating, :music_comment, :direction_rating, :direction_comment, :story_spoiler, :cast_spoiler, :music_spoiler, :direction_spoiler)
    end
end