class Movie < ApplicationRecord
  has_many :reviews
  has_many :movielists
  has_many :users, through: :movielists
end
