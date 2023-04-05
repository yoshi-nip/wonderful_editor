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

    context "指定したidのデータが返ってくること(200)" do
      let(:article) { create(:article) }
      let(:article_id) { article.id }
      it "記事詳細を取得" do
        p(subject)
        res = JSON.parse(response.body)
        expect(res.keys).to eq ["id", "title", "body", "updated_at", "user"]
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["updated_at"]).to be_present
        expect(res["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "存在しないidを指定してレコードが見つからない" do
      let(:article_id) { 100000 }
      it "記事詳細を取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "Post /articles/" do
    subject { post(api_v1_articles_path, params: { article: article_params }) }

    context "適切なパラメータをもとに記事が作成される" do
      let(:article_params) { attributes_for(:article) }
      let(:user) { create(:user) }
      before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(user) }

      it "現在のユーザをもとに記事が作成できる" do
        subject
        # post :create, params: { article: { title: "Test Article", body: "Lorem ipsum dolor sit amet" } }
        expect(Article.last.user_id).to eq(user.id)
      end
    end
  end

  describe "PATCH /articles/:id" do
    subject { patch(api_v1_article_path(article_id), params: { article: article_params }) }

    let(:article_params) { { title: Faker::Lorem.sentence } }
    let(:other_user) { create(:user) }
    let(:user) { create(:user) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(user) }

    context "自分が所持している記事のレコードを更新するとき" do
      let(:article) { create(:article, user: user) }
      let(:article_id) { article.id }

      it "記事が更新できる" do
        # post :create, params: { article: { title: "Test Article", body: "Lorem ipsum dolor sit amet" } }
        # タイトルだけ変える想定
        expect { subject }.to change { article.reload.title }.from(article.title).to(article_params[:title]) &
                              not_change { article.reload.body } &
                              not_change { article.reload.created_at }
        expect(response).to have_http_status(:ok)
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let(:article_id) { article.id }
      let!(:article) { create(:article, user: other_user) }
      it "記事が更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article_id)) }
    let(:other_user) { create(:user) }
    let(:user) { create(:user) }
    before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(user) }

    context "自分が所持している記事を削除しようとするとき" do
      let(:article) { create(:article, user: user) }
      let(:article_id) { article.id }
      fit "任意の記事を削除できる" do
        expect{ subject }.to change {Article.count}.by(0)
        expect(response).to have_http_status(200)
      end
    end

    context "自分が所持していない記事を削除しようとするとき" do
      let(:article) { create(:article, user: other_user) }
      let(:article_id) { article.id }
      fit "任意の記事を削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
