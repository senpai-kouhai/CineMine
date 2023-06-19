class MovieDetailsService
  BASE_URL = "https://api.themoviedb.org/3/movie"
  API_KEY = ENV['TMDB_API_KEY']

  def self.fetch_movie_details(movie_id)
    response = HTTParty.get("#{BASE_URL}/#{movie_id}?api_key=#{API_KEY}&language=ja")

    return nil unless response.success?

    movie_data = response.parsed_response
    movie = Movie.find_by(id: movie_id)

    if movie.nil?
      movie = Movie.create(
        id: movie_id,
        title: movie_data["title"],
        overview: movie_data["overview"],
        poster_path: movie_data["poster_path"],
        tmdb_id: movie_id,
        genre: movie_data["genres"].map{|genre| genre["name"]}.join(", ")
      )
    else
      movie.update(
        title: movie_data["title"],
        overview: movie_data["overview"],
        poster_path: movie_data["poster_path"],
        tmdb_id: movie_id,
        genre: movie_data["genres"].map{|genre| genre["name"]}.join(", ")
      )
    end

    movie
  end
end