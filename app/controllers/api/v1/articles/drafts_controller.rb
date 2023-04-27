class Api::V1::Articles::DraftsController < ApplicationController
  def index
    articles = Article.draft.order(updated_at: :desc)
    render json: articles, each_serializer: Api::V1::ArticlePreviewSerializer
  end

  def show
    article = Article.draft.find(params[:id])
    render json: article, serializer: Api::V1::ArticleSerializer
  end
end
