class Movie < ApplicationRecord
  belongs_to :user

  validates :movie_url, presence: true, format: /\A(http[s]\:\/\/)?(www\.youtube\.com|youtu\.?be)\/.+$\z/
  validates :user, presence: true
end
