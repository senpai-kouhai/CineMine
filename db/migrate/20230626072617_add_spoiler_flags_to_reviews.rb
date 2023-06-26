class AddSpoilerFlagsToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :story_spoiler, :boolean, default: false
    add_column :reviews, :cast_spoiler, :boolean, default: false
    add_column :reviews, :music_spoiler, :boolean, default: false
    add_column :reviews, :direction_spoiler, :boolean, default: false
  end
end
