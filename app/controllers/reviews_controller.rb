class ReviewsController < ApplicationController
  before_action :authenticate_user!, except: [:index]
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user, only: [:edit, :update, :destroy]

  def create
    @movie = Movie.find(params[:movie_id])
    @review = @movie.reviews.build(review_params) #buildメソッドは新しい関連オブジェクトを作成する
    @review.user = current_user
    if @review.save
      redirect_to @movie, notice: 'レビューを投稿しました。'
    else
      flash.now[:error] = 'レビューの投稿に失敗しました。'
      Rails.logger.info @review.errors.full_messages #バリデーションエラーの全てのエラーメッセージがログに出力
      @reviews = @movie.reviews.where.not(id: nil) #idカラムがnilじゃないレビューを抽出
      render 'movies/show'
    end
  end

  def show
    @comment = Comment.new
  end

  def index
    if params[:search].blank? #searchリクエストが空の場合
      @reviews = Review.all #全てのレビューを表示
    else
      @reviews = Review.search(params[:search]) #searchスコープを使って検索クエリに基づいてレビューを検索
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to movie_review_path(@review.movie, @review), notice: 'レビューを更新しました。'
    else
      flash.now[:error] = 'レビューの更新に失敗しました。'
      Rails.logger.info @review.errors.full_messages
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to movies_path, notice: 'レビューを削除しました。'
  end

  private

  def set_review
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
  end

  def authorize_user
    unless @review.user == current_user || current_user.admin?
      flash[:alert] = "あなたにはこのレビューを編集する権限がありません。"
      redirect_to movie_path(@movie)
    end
  end

  def review_params
    params.require(:review).permit(:story_rating, :story_comment, :cast_rating, :cast_comment, :music_rating, :music_comment, :direction_rating, :direction_comment, :story_spoiler, :cast_spoiler, :music_spoiler, :direction_spoiler)
  end
end
