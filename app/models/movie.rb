class Movie < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :movielists, dependent: :destroy
  has_many :users, through: :movielists, dependent: :destroy
end
