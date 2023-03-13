require "rails_helper"

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "全てが指定されているとき" do
    let(:user){build(:user)}
    fit "ユーザーが作られる" do
      # user = User.new(name: "foo",account: "foo", email: "foo@foo.com")
      # user = build(:user)
      expect(user).to be_valid
    end
  end

  context "emailが空白の時" do
    let(:user){build(:user, { email: "" })}
    fit "ユーザー作成に失敗" do
      expect(user).to be_invalid
      expect(user.errors.errors[0].attribute).to eq :email
      expect(user.errors.errors[0].type).to eq :blank
    end
  end

  context "password空白の時" do
    let(:user){build(:user,password: "")}
    fit "ユーザー作成に失敗" do
      expect(user).to be_invalid
      expect(user.errors.errors[0].attribute).to eq :password
      expect(user.errors.errors[0].type).to eq :blank
    end
  end

  context "nameが空白の時" do
    let(:user) {build(:user,name: "" )}
    fit "ユーザー作成に失敗" do
      expect(user).to be_invalid
      expect(user.errors.errors[0].attribute).to eq :name
      expect(user.errors.errors[0].type).to eq :blank
    end
  end

  context "passwordが8文字以下" do
    let(:user){build(:user,{password: "vjfysl2"})}
    fit "ユーザー作成に失敗" do
      expect(user).to be_invalid
      expect(user.errors.errors[0].attribute).to eq :password
      expect(user.errors.errors[0].type).to eq :too_short
    end
  end
end
