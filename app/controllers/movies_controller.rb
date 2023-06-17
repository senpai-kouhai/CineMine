require 'net/http'
require 'json'

class MoviesController < ApplicationController
  API_KEY = ENV['TMDB_API_KEY']
  # BASE_URL = 'https://api.themoviedb.org/3/movie/popular'

  def index
     page = params[:page] || 1
    base_url = 'https://api.themoviedb.org/3/movie/popular'
    uri = URI("#{base_url}?api_key=#{API_KEY}&page=#{page}&language=ja")
    response = Net::HTTP.get(uri)
    @movies = JSON.parse(response)['results']
  end

  def show
  end
end
