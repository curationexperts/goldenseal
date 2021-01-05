FactoryGirl.define do
  factory :admin, class: "User" do
    username 'admin'
    group_list ['admin']
  end

  factory :nonadmin, class: "User" do
    username 'nonadmin'
    group_list []
  end

end
