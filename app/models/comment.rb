class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review

  validates :user_id, presence: true
  validates :review_id, presence: true
  validates :comment, presence: true, length: { maximum: 100 }
end
