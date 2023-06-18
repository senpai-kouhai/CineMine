class MovieGenresService
  BASE_URL = 'https://api.themoviedb.org/3'
  API_KEY = ENV['TMDB_API_KEY']

  def self.fetch_genres
    Rails.cache.fetch("movie_genres", expires_in: 24.hours) do #ジャンルデータはアプリ起動時に24時間に一回読み込み、キャッシュを使いまわす
      response = HTTParty.get("#{BASE_URL}/genre/movie/list?api_key=#{API_KEY}&language=ja")
      response.parsed_response['genres']
    end
  end
end