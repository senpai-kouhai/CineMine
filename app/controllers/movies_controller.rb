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

    def search
      if params[:genre].present?
        @movies = MovieSearchService.search_by_genre(params[:genre])
      elsif params[:min_rating].present? && params[:max_rating].present?
        @movies = MovieSearchService.search_by_rating(params[:min_rating], params[:max_rating])
      else
        @movies = MovieSearchService.search_by_keyword(params[:keyword])
      end
    end
  end


  def show
  end
end
