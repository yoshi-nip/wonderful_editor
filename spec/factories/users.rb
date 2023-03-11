FactoryBot.define do
  factory :user do
    # name {"hoge"}
    # account {"hoge"}
    # email {"hoge@hoge.com"}
    name {Faker::Name.name}
    sequence(:email) { |n| "#{n}_#{Faker::Internet.email}"}
    password {Faker::Internet.password}
  end
end
