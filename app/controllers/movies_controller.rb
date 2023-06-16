class MoviesController < ApplicationController
  require 'themoviedb-api'
  Tmdb::Api.key(ENV['TMDB_API_KEY'])
  Tmdb::Api.language("ja")

  def index
    @movies = Tmdb::Movie.popular.results
  end

  def show
  end
end
