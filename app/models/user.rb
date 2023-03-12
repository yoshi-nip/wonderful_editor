# frozen_string_literal: true

class User < ApplicationRecord
  extend Devise::Models
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, password_length: 8..128
  include DeviseTokenAuth::Concerns::User

  validates :name, presence: true

  has_many :articles, dependent: :restrict_with_exception
  has_many :article_likes, dependent: :restrict_with_exception
  has_many :comment, dependent: :restrict_with_exception
end
