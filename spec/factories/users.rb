FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "person_#{n}@example.com"
    end
    password 's0s3kr3t'
  end
end
