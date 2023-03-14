FactoryBot.define do
  factory :user do
    # name {"hoge"}
    # account {"hoge"}
    # email {"hoge@hoge.com"}
    # name { Faker::Name.name }
    # sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    # password { Faker::Internet.password }
    name { Faker::Lorem.characters(number: Random.new.rand(1..30)) }
    sequence(:email) {|n| "#{n}_#{Faker::Internet.email}" }
    password { Faker::Internet.password(min_length: 8, max_length: 32, mix_case: true, special_characters: true) }
  end
end
