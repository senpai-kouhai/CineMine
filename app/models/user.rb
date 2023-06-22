class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable


  # 管理者かどうかを判断するメソッド
  def admin?
    admin
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    following.delete(other_user)
  end

  def following?(other_user)
    active_relationships.find_by(followed_id: other_user.id)
  end

  has_many :reviews

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :likes
  has_many :liked_reviews, through: :likes, source: :review

  def like(review)
    likes.create(review_id: review.id)
  end

  def like(review)
    likes.create(review_id: review.id)
  end

  def unlike(review)
    like = likes.find_by(review_id: review.id)
    if like
      like.destroy
      return like
    else
      return nil
    end
  end
end
