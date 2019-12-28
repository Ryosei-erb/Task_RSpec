FactoryBot.define do
  factory :task do
    sequence(:name) {|n| "タスク#{n}"}
    description { "RSpec & Capybara & FactoryBotを準備する"}
    association :user
  end
end
