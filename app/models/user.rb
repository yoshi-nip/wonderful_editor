class User < ApplicationRecord
  extend Devise::Models
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, password_length: 8..128
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true

  has_many :articles, dependent: :restrict_with_exception
  has_many :article_likes, dependent: :restrict_with_exception
  has_many :comment, dependent: :restrict_with_exception
end
