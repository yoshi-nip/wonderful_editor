require "rails_helper"

RSpec.describe Comment, type: :model do
  context "全てが指定されているとき" do
    let(:comment) {build(:comment)}
    fit "記事が作られる" do
      expect(comment).to be_valid
    end
  end

  context "bodyが空白の時" do
    let(:comment) {build(:comment,{body: ""})}
    fit "記事の作成に失敗" do
      expect(comment).to be_invalid
      expect(comment.errors.errors[0].attribute).to eq :body
      expect(comment.errors.errors[0].type).to eq :blank
    end
  end
end
