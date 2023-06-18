require 'httparty'

class MoviesController < ApplicationController
  API_KEY = ENV['TMDB_API_KEY']

  def index
    page = params[:page].to_i
    response = MovieIndexService.fetch_popular_movies(page)
    @movies = response['results']
    @page = page
    @total_pages = response['total_pages']

    if @movies.nil?
      flash[:alert] = "APIからデータを取得できませんでした。再度お試しください。"
      redirect_to movies_index_path(page: 1) and return
    end

    @genres = MovieGenresService.fetch_genres
  end

  def search
    if params[:genre].present?
      response = MovieSearchService.search_by_genre(params[:genre], params[:page])
    else
      response = MovieSearchService.search_by_keyword(params[:keyword], params[:page] || 1)
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
  end
end