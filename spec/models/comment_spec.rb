require "rails_helper"

RSpec.describe Comment, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"
  context "全てが指定されているとき" do
    it "記事が作られる" do
      comment = build(:comment)
      expect(comment).to be_valid
    end
  end

  context "bodyが空白の時" do
    it "記事の作成に失敗" do
      # user = User.new(name: "foo", email: "foo@foo.com")
      comment = build(:comment, { body: "" })
      expect(comment).to be_invalid
      expect(comment.errors.errors[0].attribute).to eq :body
      expect(comment.errors.errors[0].type).to eq :blank
    end
  end
end
