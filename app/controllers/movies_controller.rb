require 'httparty'

class MoviesController < ApplicationController
  API_KEY = ENV['TMDB_API_KEY']

  def index
    params[:page] ||= 1
    @genres = MovieGenresService.fetch_genres

    response = MovieIndexService.fetch_popular_movies(params[:page].to_i)
    if response['results'].nil?
      flash[:alert] = "APIからデータを取得できませんでした。再度お試しください。"
      redirect_to movies_index_path(page: 1) and return
    end

    @movies = response['results']
    @page = params[:page].to_i
    @total_pages = response['total_pages']
  end

  def search
    params[:page] ||= 1

    if params[:genre].present?
      response = MovieSearchService.search_by_genre(params[:genre], params[:page])
    else
      response = MovieSearchService.search_by_keyword(params[:keyword], params[:page])
    end

    @movies = response['results']
    @page = params[:page].to_i
    @total_pages = response['total_pages']

    if @movies.nil?
      flash[:alert] = "APIからデータを取得できませんでした。再度お試しください。"
      redirect_to search_movies_path(page: 1, genre: params[:genre], keyword: params[:keyword]) and return
    end
  end

  def show
    movie_id = params[:id]
    @movie = MovieDetailsService.fetch_movie_details(movie_id)

    if @movie.nil?
      flash[:alert] = "映画の詳細を取得できませんでした。再度お試しください。"
      redirect_to movies_path and return
    end

    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.includes(:user).order(created_at: :desc)
  end
end