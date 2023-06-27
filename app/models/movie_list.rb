class MovieList < ApplicationRecord
  belongs_to :user
  belongs_to :movie, optional: true

  validates :user_id, uniqueness: { scope: :movie_id }

  def movie_details
    movie || MovieDetailsService.fetch_movie_details(self.tmdb_id)
  end
end