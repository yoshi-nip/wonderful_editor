require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /api/v1/users" do
    subject { post(api_v1_user_registration_path,params: user_params) }
    context "適切なパラメータをもとにユーザが作成される" do
      let(:user_params) { {user: attributes_for(:user)} }
      fit "新規ユーザーが作られる" do
        expect { subject }.to change { User.count }.by(1)
        res = JSON.parse(response.body)
        # binding.pry
        expect(res["data"]["name"]).to eq user_params[:user][:name]
        expect(res["data"]["email"]).to eq user_params[:user][:email]
        expect(response).to have_http_status(200)
      end
    end

    context "不適切なパラメータが送れた時はエラーが起こりユーザが作成されない" do
      let(:user_params) { attributes_for(:user) }
      fit "エラーが返ってくる" do
        binding.pry
        expect { subject }.to raise_error ActionController::ParameterMissing
      end
    end

  end
end
