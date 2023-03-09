class Article < ApplicationRecord
  belongs_to :user
  has_many :article_likes, dependent: :restrict_with_exception
  has_many :comment, dependent: :restrict_with_exception
end
