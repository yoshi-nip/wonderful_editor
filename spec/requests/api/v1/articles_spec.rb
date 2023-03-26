require "rails_helper"

RSpec.describe "Article", type: :request do
  # users GET    /users(.:format)users#index {:format=>:json}
  # ユーザー一覧が取得できる
  # 返ってきたデータはname,account, emailを持つこと
  # 正常なレスポンスコードか返ってきている
  describe "GET /articles" do
    # subject { get users_path }
    subject { get(api_v1_articles_path) }

    # before { create_list(:article, 3) }
    let!(:article1) { create(:article, updated_at: 1.days.ago) }
    let!(:article2) { create(:article, updated_at: 2.days.ago) }
    let!(:article3) { create(:article, title: "一番最初") }

    it "記事の一覧を取得できる" do
      p(subject)
      res = JSON.parse(response.body)
      # res.length = 3
      expect(res.length).to eq 3
      expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
      expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "user"]
      expect(res[0]["user"].keys).to eq ["id", "name", "email"]
      # expect(res.keys).to eq ["id", "account", "name", "created_at", "updated_at", "email"]
      # binding.pry
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    let!(:article) { create(:article) }
    let!(:article_id) { article.id }

    it "記事の詳細を取得できる" do
      p(subject)
      res = JSON.parse(response.body)
      expect(res.length).to eq 5
      expect(res.keys).to eq ["id", "title", "body", "updated_at", "user"]
      expect(res["user"].keys).to eq ["id", "name", "email"]
      expect(response).to have_http_status(:ok)
    end
  end
end
