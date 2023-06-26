class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user, dependent: :destroy

  def self.search(query)
    where("story_comment LIKE ? OR cast_comment LIKE ? OR music_comment LIKE ? OR direction_comment LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
  end
end
