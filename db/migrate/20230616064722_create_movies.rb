class CreateMovies < ActiveRecord::Migration[6.1]
  def change
    create_table :movies do |t|
      t.string :title
      t.integer :tmdb_id
      t.string :genre
      t.text :overview
      t.string :poster_path

      t.timestamps
    end
  end
end
