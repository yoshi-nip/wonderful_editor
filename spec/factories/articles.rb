FactoryBot.define do
  factory :article do
    # name {"hoge"}
    # account {"hoge"}
    # email {"hoge@hoge.com"}
    title { Faker::Lorem.sentence }
    body { Faker::Lorem.sentence }
    user

    trait :draft do
      status { :draft }
    end

    trait :published do
      status { :published }
    end
  end
end
