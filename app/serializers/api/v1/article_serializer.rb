class Api::V1::ArticleSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at, :status
  # binding.pry
  belongs_to :user, serializer: Api::V1::UserSerializer
end
