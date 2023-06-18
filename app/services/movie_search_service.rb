class MovieSearchService
  BASE_URL = 'https://api.themoviedb.org/3'
  API_KEY = ENV['TMDB_API_KEY']

  def self.search_by_keyword(keyword)
    response = HTTParty.get("#{BASE_URL}/search/movie?api_key=#{API_KEY}&query=#{URI.encode_www_form_component(keyword)}&language=ja")
    response.parsed_response
  end

  def self.search_by_genre(genre_id)
    response = HTTParty.get("#{BASE_URL}/discover/movie?api_key=#{API_KEY}&with_genres=#{genre_id}&language=ja")
    response.parsed_response
  end

  def self.search_by_rating(min_rating, max_rating)
    response = HTTParty.get("#{BASE_URL}/discover/movie?api_key=#{API_KEY}&vote_average.gte=#{min_rating}&vote_average.lte=#{max_rating}&language=ja")
    response.parsed_response
  end
end