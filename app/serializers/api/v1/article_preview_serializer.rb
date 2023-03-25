class Api::V1::ArticlePreviewSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :updated_at
  # binding.pry
  belongs_to :user, serializer: Api::V1::UserSerializer
end
