FactoryBot.define do
  factory :article_like do
    # name {"hoge"}
    # account {"hoge"}
    # email {"hoge@hoge.com"}
    user
    article
  end
end
