class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.integer :story_rating
      t.text :story_comment
      t.integer :cast_rating
      t.text :cast_comment
      t.integer :music_rating
      t.text :music_comment
      t.integer :direction_rating
      t.text :direction_comment
      t.integer :movie_id
      t.integer :user_id

      t.timestamps
    end
  end
end
