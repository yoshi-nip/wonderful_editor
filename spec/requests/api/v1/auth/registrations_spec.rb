require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /api/v1/users" do
    subject { post(api_v1_user_registration_path, params: user_params) }

    context "適切なパラメータが送信されたとき" do
      let(:user_params) { { user: attributes_for(:user) } }
      it "新規ユーザーが作られる" do
        expect { subject }.to change { User.count }.by(1)
        res = JSON.parse(response.body)
        expect(res["data"]["name"]).to eq user_params[:user][:name]
        expect(res["data"]["email"]).to eq user_params[:user][:email]
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

    context "不適切なパラメータが送れた時" do
      let(:user_params) { attributes_for(:user) }
      it "エラーが返ってくる" do
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end

    context "nameがない時" do
      let(:user_params) { { user: attributes_for(:user, name: nil) } }
      it "エラーが返ってくる" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "emailがない時" do
      let(:user_params) { { user: attributes_for(:user, email: nil) } }
      it "エラーが返ってくる" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "passwordがない時" do
      let(:user_params) { { user: attributes_for(:user, password: nil) } }
      it "エラーが返ってくる" do
        subject
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
end
