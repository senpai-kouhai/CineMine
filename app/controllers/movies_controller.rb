class MoviesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :search]
  before_action :set_page, only: [:index, :search]
  API_KEY = ENV['TMDB_API_KEY']

  def index
    @genres = MovieGenresService.fetch_genres
    response = MovieIndexService.fetch_popular_movies(@page)

    unless response['results'] #APIレスポンスがfalseだった場合
      return handle_failed_api_response(movies_index_path(page: 1)) #1page目へリダイレクト
    end

    assign_movie_data(response)
  end

  def search
    response = if params[:genre].present? #ジャンルがあるもののみジャンルで検索可能
      MovieSearchService.search_by_genre(params[:genre], @page)
    else
      MovieSearchService.search_by_keyword(params[:keyword], @page)
    end

    unless response['results']
      return handle_failed_api_response(search_movies_path(page: 1, genre: params[:genre], keyword: params[:keyword]))
    end

    assign_movie_data(response)
  end

  def show
    movie_id = params[:id]
    @movie = MovieDetailsService.fetch_movie_details(movie_id)

    unless @movie
      return handle_failed_api_response(movies_path)
    end

    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.includes(:user).order(created_at: :desc)
  end

  def add_to_movielist
    current_user.add_to_movielist(params[:id])
    flash[:notice] = "視聴リストに追加しました"
    redirect_to movie_path(params[:id])
  end

  def remove_from_movielist
    current_user.remove_from_movielist(params[:id])
    flash[:notice] = "視聴リストから削除しました"
    redirect_to movie_path(params[:id])
  end

  private

  def set_page
    @page = (params[:page] || 1).to_i
  end

  def assign_movie_data(response)
    @movies = response['results']
    @total_pages = response['total_pages']
  end

  def handle_failed_api_response(redirect_path)
    flash[:alert] = "APIからデータを取得できませんでした。再度お試しください。"
    redirect_to redirect_path
  end
end
