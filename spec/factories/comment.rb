FactoryBot.define do
  factory :comment do
    # name {"hoge"}
    # account {"hoge"}
    # email {"hoge@hoge.com"}
    body { Faker::Lorem.paragraphs }
    user
    article
  end
end
