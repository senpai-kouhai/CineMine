class MovieIndexService
  BASE_URL = 'https://api.themoviedb.org/3/movie/popular'
  API_KEY = ENV['TMDB_API_KEY']

  def self.fetch_popular_movies(page)
    page = 1 if page < 1
    page = 1000 if page > 1000 #リクエストできるのは1000ページまで
    response = HTTParty.get("#{BASE_URL}?api_key=#{API_KEY}&page=#{page}&language=ja")
    response.parsed_response
  end
end