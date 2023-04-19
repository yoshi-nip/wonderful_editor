require "rails_helper"

RSpec.describe "Api::V1::Auth::Registrations", type: :request do
  describe "GET /index" do
    pending "add some examples (or delete) #{__FILE__}"
  end

  describe "POST /api/v1/users/sing_in" do
    subject { post(api_v1_user_session_path, params: user_params) }

    context "適切なパラメータが送信されたとき" do
      # 登録してあるユーザーのemail,passwordを送信したらログインができる
      # ログインしたらtoken情報が返ってくる
      # パラメータが違かったらエラーが起きる
      # パラメータがない場合エラーが起きる
      let(:user) { create(:user) }
      let(:user_params) { {  email: user.email, password: user.password } }
      it "ログインができる" do
        subject
        # res = JSON.parse(response.body)
        # expect(res["data"]["name"]).to eq user_params[:user][:name]
        # expect(res["data"]["email"]).to eq user_params[:user][:email]
        expect(response).to have_http_status(:ok)
      end

      it "想定したヘッダー情報が返ってくる" do
        subject
        expected_headers = ["token-type", "access-token", "client", "uid", "expiry", "authorization"]
        expected_headers.each do |header_key|
          expect(response.header[header_key]).to be_present
        end
      end

      #   expect(response.header["token-type"]).to be_present
      #   expect(response.header["access-token"]).to be_present
      #   expect(response.header["client"]).to be_present
      #   expect(response.header["uid"]).to be_present
      #   expect(response.header["expiry"]).to be_present
      #   expect(response.header).to have_http_status(:ok)
      # end
    end

    context "余計なnameがある時" do
      let(:user) { create(:user) }
      let(:user_params) { attributes_for(:user) }
      it "余計なnameがある時エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
      end
    end

    context "passwordがない時" do
      let(:user) { create(:user) }
      let(:user_params) { {  email: user.email, password: nil } }
      # let(:user_params) { attributes_for(:user,name: nil) }
      it "エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
        # subject
        # # expect { subject }.to raise_error ActionController::ParameterMissing
        # expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "emailがない時" do
      let(:user) { create(:user) }
      let(:user_params) { {  email: nil, password: user.password } }
      # let(:user_params) { attributes_for(:user,name: nil) }
      it "エラーが返ってくる" do
        expect { subject }.to raise_error NoMethodError
      end
    end

    context "passwordが違う時" do
      let(:user) { create(:user) }
      let(:user_params) { {  email: user.email, password: "mineraruwater" } }
      # let(:user_params) { attributes_for(:user,name: nil) }
      it "エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
        # subject
        # # expect { subject }.to raise_error ActionController::ParameterMissing
        # expect(response).to have_http_status(:unprocessable_entity)
      end
    end

    context "emailが違う時" do
      let(:user) { create(:user) }
      let(:user_params) { {  email: "mineraruwater@mineraru.com", password: user.password } }
      # let(:user_params) { attributes_for(:user,name: nil) }
      it "エラーが返ってくる" do
        subject
        res = JSON.parse(response.body)
        expect(res["errors"]).to be_present
        # subject
        # # expect { subject }.to raise_error ActionController::ParameterMissing
        # expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /api/v1/auth/sign_out" do
    subject { delete(destroy_api_v1_user_session_path, headers:) }

    context "ヘッダー情報が正しく、正常なdeleteメソッドが送られる時" do
      let(:user) { create(:user) }
      let!(:headers) { user.create_new_auth_token }
      it "ログアウトが成功する" do
        # ログイン状態を確認
        # ログアウトのアクションを実行
        # ログアウトの結果を確認
        expect { subject }.to change { user.reload.tokens.present? }.from(true).to(false)
        expect(response).to have_http_status(:ok) # ログアウト後のレスポンスステータスを確認
      end
    end

    context "ヘッダー情報が正しくない時" do
      let(:user) { create(:user) }
      let!(:headers) {
        { "access-token" => "1111",
          "token-type" => "kbndk",
          "client" => "rrrr",
          "expiry" => "35353",
          "uid" => "222",
          "authorization" => "" }
      }
      it "ログアウトが失敗する" do
        # ログイン状態を確認
        # ログアウトのアクションを実行
        # ログアウトの結果を確認
        # expect {subject}.to change {user.reload.tokens.present?}.from(true).to(false)
        subject
        res = JSON.parse(response.body)
        expect(res["success"]).to eq false
        expect(res["errors"][0]).to eq "User was not found or was not logged in."
        expect(response).to have_http_status(:not_found) # ログアウト後のレスポンスステータスを確認
      end
    end
  end
end
