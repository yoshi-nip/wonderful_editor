require "rails_helper"

RSpec.describe "Article", type: :request do
  # users GET    /users(.:format)users#index {:format=>:json}
  # ユーザー一覧が取得できる
  # 返ってきたデータはname,account, emailを持つこと
  # 正常なレスポンスコードか返ってきている
  describe "GET /articles" do

    subject { get(api_v1_articles_path) }

    context "記事がpublishedの時" do
    # before { create_list(:article, 3) }
      let!(:article1) { create(:article, :published ,updated_at: 1.days.ago) }
      let!(:article2) { create(:article, :published,updated_at: 2.days.ago) }
      let!(:article3) { create(:article, :published,title: "一番最初") }

      fit "記事の一覧を取得できる" do
        p(subject)
        res = JSON.parse(response.body)
        # res.length = 3
        expect(res.length).to eq 3
        expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        # expect(res.keys).to eq ["id", "account", "name", "created_at", "updated_at", "email"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "記事がdraftの時" do
      # before { create_list(:article, 3) }
        let!(:article1) { create(:article, :draft ,updated_at: 1.days.ago) }
        let!(:article2) { create(:article, :draft,updated_at: 2.days.ago) }
        let!(:article3) { create(:article, :draft,title: "一番最初") }

        fit "記事の一覧を取得できない" do
          p(subject)
          res = JSON.parse(response.body)
          expect(res.length).to eq 0
          expect(response).to have_http_status(:ok)
        end
      end
  end

  describe "GET /articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidが存在して" do
      let(:article_id) { article.id }
      context "公開中であるとき" do
        let(:article) { create(:article,:published) }
        fit "記事詳細を取得" do
          p(subject)
          res = JSON.parse(response.body)
          expect(res.keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["status"]).to eq ("published")
          expect(res["user"].keys).to eq ["id", "name", "email"]
          expect(response).to have_http_status(:ok)
        end
      end

      context "記事が下書き状態であるとき" do
        let(:article) { create(:article, :draft) }

        fit "記事が見つからずエラーが出る" do
          expect { subject }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    context "存在しないidを指定してレコードが見つからない" do
      let(:article_id) { 100000 }
      it "記事詳細を取得できない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /articles/" do
    subject { post(api_v1_articles_path, params: { article: article_params }, headers:) }

    let(:user) { create(:user) }
    # let(:article_draft_or_published) {{draft: attributes_for(:article,:draft),published: attributes_for(:article,:published),fff: }}
    # let(:article_params) { attributes_for(:article).merge(status: status_params) }

    context "ログインユーザーの時、適切なパラメータをもとに記事が作成される" do
      let!(:headers) { user.create_new_auth_token }
      let(:article_params) { attributes_for(:article,:draft) }
      # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_api_v1_user).and_return(user) }
      fit "現在のユーザをもとに記事が作成できる" do
        subject
        expect(Article.last.user_id).to eq(user.id)
        expect(Article.last.status).to eq("draft")
        expect(response).to have_http_status(:ok)
      end

      it "想定したヘッダー情報が返ってくる" do
        subject
        expected_headers = ["token-type", "access-token", "client", "uid", "expiry", "authorization"]
        expected_headers.each do |header_key|
          expect(response.header[header_key]).to be_present
        end
      end
    end

    context "公開ステータスの時も正常に保存できる" do
      let!(:headers) { user.create_new_auth_token }
      let(:article_params) { attributes_for(:article,:published) }
      # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_api_v1_user).and_return(user) }
      fit "正常に保存できる" do

        subject
        expect(Article.last.user_id).to eq(user.id)
        expect(Article.last.status).to eq("published")
        expect(response).to have_http_status(:ok)
      end
    end

    # 異常系テスト
    context "tokenを渡していない時、記事が作成されない" do
      let(:article_params) { attributes_for(:article,:published) }
      it "エラーが起きる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"][0]).to eq "You need to sign in or sign up before continuing."
      end
    end

    context "token情報が違う時" do
      let(:article_params) { attributes_for(:article,:published) }
      let!(:headers) {
        { "access-token" => "1111",
          "token-type" => "kbndk",
          "client" => "rrrr",
          "expiry" => "35353",
          "uid" => "222",
          "authorization" => "" }
      }
      it "エラーが起きる" do
        subject
        res = JSON.parse(response.body)
        # expect(response).to have_http_status(:unauthorized)
        expect(res["errors"][0]).to eq "You need to sign in or sign up before continuing."
      end
    end

    context "tokenは正しいが" do
      let!(:headers) { user.create_new_auth_token }
      context "でたらめな指定で記事を作成するとき" do
        let(:article_params) { attributes_for(:article,status: :foo) }

        fit "エラーになる" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "PATCH /articles/:id" do
    subject { patch(api_v1_article_path(article_id), params: { article: article_params }, headers:) }
    let(:article_params) { attributes_for(:article, :published)  }
    let(:article_id) { article.id }
    let(:user) { { user: create(:user), other_user: create(:user) } }
    # let(:other_user) { create(:user) }
    # let(:user) { create(:user) }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_api_v1_user).and_return(user) }

    context "自分が所持している記事のレコードを更新するとき" do
      let!(:headers) { user[:user].create_new_auth_token }
      let!(:article) { create(:article,:draft ,user: user[:user]) }

      fit "記事が更新できる(下書き>公開)" do
        # post :create, params: { article: { title: "Test Article", body: "Lorem ipsum dolor sit amet" } }
        # タイトルだけ変える想定
        binding.pry
        expect { subject }.to change { article.reload.title }.from(article.title).to(article_params[:title]) &
                              change { article.reload.body }.from(article.body).to(article_params[:body]) &
                              change { article.reload.status }.from(article.status).to(article_params[:status].to_s)
        res = JSON.parse(response.body)
        expect(res["status"]).to eq ("published")
        expect(response).to have_http_status(:ok)
      end

      it "想定したヘッダー情報が返ってくる" do
        subject
        expected_headers = ["token-type", "access-token", "client", "uid", "expiry", "authorization"]
        expected_headers.each do |header_key|
          expect(response.header[header_key]).to be_present
        end
      end
    end

    context "token情報が違う時、記事が更新できない" do
      let(:article) { create(:article, user: user[:user]) }
      let!(:headers) {
        { "access-token" => "1111",
          "token-type" => "kbndk",
          "client" => "rrrr",
          "expiry" => "35353",
          "uid" => "222",
          "authorization" => "" }
      }
      it "エラーが起きる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:unauthorized)
        expect(res["errors"][0]).to eq "You need to sign in or sign up before continuing."
      end
    end

    context "自分が所持していない記事のレコードを更新しようとするとき" do
      let!(:article) { create(:article, user: user[:other_user]) }
      let!(:headers) { user[:user].create_new_auth_token }
      it "記事が更新できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /articles/:id" do
    subject { delete(api_v1_article_path(article_id), headers:) }

    let(:other_user) { create(:user) }
    let(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }
    # before { allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_api_v1_user).and_return(user) }

    context "自分が所持している記事を削除しようとするとき" do
      let(:article) { create(:article, user:) }
      let(:article_id) { article.id }
      it "任意の記事を削除できる" do
        expect { subject }.to change { Article.count }.by(0)
        expect(response).to have_http_status(:ok)
      end

      it "想定したヘッダー情報が返ってくる" do
        subject
        expected_headers = ["token-type", "access-token", "client", "uid", "expiry", "authorization"]
        expected_headers.each do |header_key|
          expect(response.header[header_key]).to be_present
        end
      end
    end

    context "自分が所持していない記事を削除しようとするとき" do
      let(:article) { create(:article, user: other_user) }
      let(:article_id) { article.id }
      it "任意の記事を削除できない" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
