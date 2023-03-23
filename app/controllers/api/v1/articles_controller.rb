module Api
  module V1
    class ArticlesController < BaseApiController
      def index
        articles = Article.all.order(updated_at: "desc")
        render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
      end
    end
  end
end
