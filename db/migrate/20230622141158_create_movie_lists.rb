class CreateMovieLists < ActiveRecord::Migration[6.1]
  def change
    create_table :movie_lists do |t|

      t.timestamps
    end
  end
end
