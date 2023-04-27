require "rails_helper"

RSpec.describe "Api::V1::Current::Articles", type: :request do
  describe "GET /api/v1/current/articles" do
    subject { get(api_v1_current_articles_path, headers:) }

    let!(:user) { create(:user) }
    let!(:headers) { user.create_new_auth_token }
    context "記事がpublishedの時" do
      # before { create_list(:article, 3) }
      let!(:article1) { create(:article, :published, updated_at: 1.days.ago, user:) }
      let!(:article2) { create(:article, :published, updated_at: 2.days.ago, user:) }
      let!(:article3) { create(:article, :published, title: "一番最初", user:) }
      it "記事の一覧を取得できる" do
        p(subject)
        res = JSON.parse(response.body)
        # res.length = 3
        expect(res.length).to eq 3
        expect(res.map {|d| d["id"] }).to eq [article3.id, article1.id, article2.id]
        expect(res[0].keys).to eq ["id", "title", "body", "updated_at", "status", "user"]
        expect(res[0]["user"].keys).to eq ["id", "name", "email"]
        # expect(res.keys).to eq ["id", "account", "name", "created_at", "updated_at", "email"]
        expect(response).to have_http_status(:ok)
      end
    end

    context "記事がdraftの時" do
      # before { create_list(:article, 3) }
      let!(:article1) { create(:article, :draft, updated_at: 1.days.ago) }
      let!(:article2) { create(:article, :draft, updated_at: 2.days.ago) }
      let!(:article3) { create(:article, :draft, title: "一番最初") }

      it "記事の一覧を取得できない" do
        p(subject)
        res = JSON.parse(response.body)
        expect(res.length).to eq 0
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
