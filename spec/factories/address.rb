FactoryBot.define do
  factory :address, class: Address do
    user
    sequence(:nickname) { |n| "nickname_#{n}" }
    sequence(:street_address) { |n| "street address #{n}" }
    sequence(:city) { |n| "City #{n}" }
    sequence(:state) { |n| "State #{n}" }
    sequence(:zip) { |n| "Zip #{n}" }
    active { true }
  end
end
