FactoryGirl.define do
  factory :user do
    sequence :username do |n|
      "person_#{n}"
    end

    group_list []

    # Prevent ldap from being called
    groups_list_expires_at { 1.day.from_now }
  end
end
