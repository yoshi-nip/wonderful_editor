require 'rails_helper'

RSpec.describe User, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "全てが指定されているとき" do
    it "ユーザーが作られる" do
      # user = User.new(name: "foo",account: "foo", email: "foo@foo.com")
      user = build(:user)
      expect(user).to be_valid
    end
  end

  context "nameが空白の時" do
    fit "ユーザー作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      user = build(:user,{name: ""})
      expect(user).to be_invalid
      binding.pry
      expect(user.errors.errors[0].attribute).to eq :name
      expect(user.errors.errors[0].type).to eq :blank
    end
  end

  context "passwordが8文字以下" do
    it "ユーザー作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      user = build(:user,{password: "bla32"})
      expect(user).to be_invalid
      expect(user.errors.errors[0].attribute).to eq :password
      expect(user.errors.errors[0].type).to eq :too_short
      # expect(user.errors.details[:account][0][:error]).to eq :blank
    end
  end

  # context "acoountが存在していない時" do
  #   it "ユーザーが作られる" do
  #   end
  # end

  # context "accountが存在しているとき" do
  #   before { create(:user,{name: "bar",account: "foo", email: "bar@foo.com"}) }
  #   it "ユーザー作成に失敗" do
  #     # User.create!(name: "bar",account: "foo", email: "bar@foo.com")
  #     # binding.pry
  #     user = build(:user,{name: "foo",account: "foo", email: "foo@foo.com"})
  #     expect(user).to be_invalid
  #     expect(user.errors.details[:account][0][:error]).to eq :taken
  #   end
  # end
end
