require "rails_helper"

RSpec.describe Article, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "全てが指定されているとき" do
    let(:article) { build(:article) }
    it "記事が作られる" do
      expect(article).to be_valid
    end
  end

  context "titleが空白の時" do
    let(:article) { build(:article, { title: "" }) }
    it "記事の作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      expect(article).to be_invalid
      expect(article.errors.errors[0].attribute).to eq :title
      expect(article.errors.errors[0].type).to eq :blank
    end
  end

  context "body空白の時" do
    let(:article) { build(:article, { body: "" }) }
    it "記事の作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      article = build(:article, { body: "" })
      expect(article).to be_invalid
      expect(article.errors.errors[0].attribute).to eq :body
      expect(article.errors.errors[0].type).to eq :blank
    end
  end
end
