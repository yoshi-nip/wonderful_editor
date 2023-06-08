require "rails_helper"

RSpec.describe "Api::V1::Articles::Drafts", type: :request do
  describe "GET /api/v1/articles/drafts/" do
    subject { get(api_v1_articles_drafts_path) }

    context "記事がdraftの時" do
      let!(:article1) { create(:article, :draft, updated_at: 1.days.ago) }
      let!(:article2) { create(:article, :draft, updated_at: 2.days.ago) }
      let!(:article3) { create(:article, :draft, title: "一番最初") }

      it "記事の一覧を取得できる" do
        p(subject)
        res = JSON.parse(response.body)
        expect(res.length).to eq 3
        expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "記事がpublishedの時" do
      let!(:article1) { create(:article, :published, updated_at: 1.days.ago) }
      let!(:article2) { create(:article, :published, updated_at: 2.days.ago) }
      let!(:article3) { create(:article, :published, title: "一番最初") }

      it "記事の一覧を取得できない" do
        p(subject)
        res = JSON.parse(response.body)
        expect(res.length).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end
  end

  describe "GET /api/v1/articles/drafts/:id" do
    subject { get(api_v1_articles_draft_path(article_id)) }

    context "指定したidが存在して" do
      let(:article_id) { article.id }
      context "下書きであるとき" do
        let(:article) { create(:article, :draft) }
        it "記事詳細を取得" do
          p(subject)
          res = JSON.parse(response.body)
          expect(res.keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
          expect(res["id"]).to eq article.id
          expect(res["title"]).to eq article.title
          expect(res["body"]).to eq article.body
          expect(res["updated_at"]).to be_present
          expect(res["status"]).to eq("draft")
          expect(res["user"].keys).to eq ["id", "name", "email"]
          expect(response).to have_http_status(:ok)
        end
      end

      context "記事が公開状態であるとき" do
        let(:article) { create(:article, :published) }

        it "記事が見つからずエラーが出る" do
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
end
