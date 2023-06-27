class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }
  validates :introduction, length: { maximum: 100 }

  has_many :comments, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy

  # 管理者かどうかを判断するメソッド
  def admin?
    self.admin
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

  has_many :reviews, dependent: :destroy

  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed, dependent: :destroy

  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower, dependent: :destroy

  has_many :likes, dependent: :destroy
  has_many :liked_reviews, through: :likes, source: :review, dependent: :destroy

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

  has_many :movie_lists, dependent: :destroy
  has_many :listed_movies, through: :movie_lists, source: :movie, dependent: :destroy

  def add_to_movielist(tmdb_id)
    movie = Movie.find_by(tmdb_id: tmdb_id)

    if movie
      movie_lists.create(movie: movie, tmdb_id: tmdb_id)
    else
      movie_lists.create(tmdb_id: tmdb_id)
    end
  end

  def remove_from_movielist(tmdb_id)
    movie_lists.find_by(tmdb_id: tmdb_id).destroy
  end

  attr_writer :login

  def login
    @login || self.username || self.email
  end

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    elsif conditions.has_key?(:username) || conditions.has_key?(:email)
      where(conditions.to_h).first
    end
  end

  def self.search(search)
    if search
      where('username LIKE ?', "%#{search}%")
    else
      all
    end
  end
end
