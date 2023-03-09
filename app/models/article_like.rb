class ArticleLike < ApplicationRecord
  belongs_to :user
  belongs_to :articles
end
