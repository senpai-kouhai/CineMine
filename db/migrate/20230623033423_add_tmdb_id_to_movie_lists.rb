class AddTmdbIdToMovieLists < ActiveRecord::Migration[6.1]
  def change
    add_column :movie_lists, :tmdb_id, :integer
  end
end
