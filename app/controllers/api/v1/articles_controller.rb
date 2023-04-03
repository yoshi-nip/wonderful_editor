module Api
  module V1
    class ArticlesController < BaseApiController
      def index
        articles = Article.order(updated_at: :desc)
        render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
      end

      def show
        article = Article.find(params[:id])
        render json: article, serializer: Api::V1::ArticleSerializer
      end

      def create
        article = current_user.articles.create!(article_params)
        render json: article, serializer: Api::V1::ArticleSerializer
      end

      private
      #Storong Parameter
      def article_params
        params.require(:article).permit(:title, :body)
      end
    end
  end
end
