class Article < ApplicationRecord
  belongs_to :user
  has_many :article_likes, dependent: :restrict_with_exception
end
