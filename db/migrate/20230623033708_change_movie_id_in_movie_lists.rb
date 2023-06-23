class ChangeMovieIdInMovieLists < ActiveRecord::Migration[6.1]
  def change
    change_column_null :movie_lists, :movie_id, true
  end
end
