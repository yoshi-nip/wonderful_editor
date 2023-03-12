require "rails_helper"

RSpec.describe ArticleLike, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "全てが指定されているとき" do
    it "記事が作られる" do
      article_like = build(:article_like)
      expect(article_like).to be_valid
    end
  end

  context "idどちらがが空白の時" do
    it "記事の作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      article_like = build(:article_like, { user_id: nil })
      expect(article_like).to be_invalid
      expect(article_like.errors.errors[0].attribute).to eq :user
      expect(article_like.errors.errors[0].type).to eq :blank
    end
  end
end
