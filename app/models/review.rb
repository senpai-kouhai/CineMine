class Review < ApplicationRecord
  belongs_to :movie
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_users, through: :likes, source: :user, dependent: :destroy
  before_save :calculate_sentiment_score

  validates :story_rating, presence: true
  validates :story_comment, presence: true, length: { maximum: 100 }

  validates :cast_rating, presence: true
  validates :cast_comment, presence: true, length: { maximum: 100 }

  validates :music_rating, presence: true
  validates :music_comment, presence: true, length: { maximum: 100 }

  validates :direction_rating, presence: true
  validates :direction_comment, presence: true, length: { maximum: 100 }

  validates :movie_id, presence: true
  validates :user_id, presence: true

  def self.search(query)
    where("story_comment LIKE ? OR cast_comment LIKE ? OR music_comment LIKE ? OR direction_comment LIKE ?", "%#{query}%", "%#{query}%", "%#{query}%", "%#{query}%")
  end

  private

  def calculate_sentiment_score
    story_score = Language.get_data(story_comment)
    cast_score = Language.get_data(cast_comment)
    music_score = Language.get_data(music_comment)
    direction_score = Language.get_data(direction_comment)

    self.sentiment_score = (story_score + cast_score + music_score + direction_score) / 4.0
  end
end
