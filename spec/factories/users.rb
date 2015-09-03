FactoryGirl.define do
  factory :user do
    sequence :username do |n|
      "person_#{n}"
    end
  end
end
