class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true

  belongs_to :user
  has_many :article_likes, dependent: :restrict_with_exception
  has_many :comment, dependent: :restrict_with_exception

  enum status: { draft: 0, published: 1 }
end
