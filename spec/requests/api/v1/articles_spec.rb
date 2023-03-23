require "rails_helper"

RSpec.describe "Article", type: :request do
  # users GET    /users(.:format)users#index {:format=>:json}
  # ユーザー一覧が取得できる
  # 返ってきたデータはname,account, emailを持つこと
  # 正常なレスポンスコードか返ってきている
  describe "GET /articles" do
    # subject { get users_path }
    subject { get(api_v1_articles_path) }

    before { create_list(:article, 3) }

    it "記事の一覧を取得できる" do
      p(subject)
      res = JSON.parse(response.body)
      # res.length = 3
      expect(res.length).to eq 3
      # expect(res["id"].keys).to eq ["id", "account", "name", "created_at", "updated_at", "email"]
      # binding.pry
      expect(response).to have_http_status(:ok)
    end
  end
end
