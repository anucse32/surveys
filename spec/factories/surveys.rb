FactoryBot.define do
  factory :survey do
    sequence(:question) { |n| "Do you like sample question #{n}?" }
  end
end
