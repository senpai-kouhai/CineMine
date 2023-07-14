class User < ApplicationRecord
  # Include default devise modules.
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 20 }
  validates :introduction, length: { maximum: 100 }

  # Association
  has_many :comments, dependent: :destroy
  has_one_attached :profile_image, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :liked_reviews, through: :likes, source: :review, dependent: :destroy
  has_many :movie_lists, dependent: :destroy
  has_many :listed_movies, through: :movie_lists, source: :movie, dependent: :destroy
  has_many :active_relationships, class_name: 'Relationship',
                                  foreign_key: 'follower_id',
                                  dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed, dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
                                   foreign_key: 'followed_id',
                                   dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower, dependent: :destroy

  # Custom methods
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

  def like(review)
    likes.create(review_id: review.id)
  end

  def unlike(review)
    like = likes.find_by(review_id: review.id)
    like&.destroy
  end

  def add_to_movielist(tmdb_id)
    movie = Movie.find_by(tmdb_id: tmdb_id)
    movie ? movie_lists.create(movie: movie, tmdb_id: tmdb_id) : movie_lists.create(tmdb_id: tmdb_id)
  end

  def remove_from_movielist(tmdb_id)
    movie_lists.find_by(tmdb_id: tmdb_id).destroy
  end

  def login
    @login || self.username || self.email
  end

  # Class methods
  class << self
    def find_for_database_authentication(warden_conditions)
      conditions = warden_conditions.dup
      login = conditions.delete(:login)

      return find_by_login(conditions, login) if login

      find_by_username_or_email(conditions) if conditions.has_key?(:username) || conditions.has_key?(:email)
    end

    def find_by_login(conditions, login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    end

    def find_by_username_or_email(conditions)
      where(conditions.to_h).first
    end

    def search(search)
      search ? where('username LIKE ?', "%#{search}%") : all
    end
  end
end
