require "rails_helper"

RSpec.describe Article, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "全てが指定されているとき" do
    it "記事が作られる" do
      article = build(:article)
      expect(article).to be_valid
    end
  end

  context "titleが空白の時" do
    it "記事の作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      article = build(:article, { title: "" })
      expect(article).to be_invalid
      expect(article.errors.errors[0].attribute).to eq :title
      expect(article.errors.errors[0].type).to eq :blank
    end
  end

  context "body空白の時" do
    it "記事の作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      article = build(:article, { body: "" })
      expect(article).to be_invalid
      expect(article.errors.errors[0].attribute).to eq :body
      expect(article.errors.errors[0].type).to eq :blank
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
