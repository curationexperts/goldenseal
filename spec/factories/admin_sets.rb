FactoryGirl.define do
  factory :admin_set do
    title "test admin set"
    identifier "admin001"
    description 'Portraits taken by Anne Leibovitz'
    creator     ['Leibovitz, Anna-Lou "Anne"']
    contributor ['Loengard, John']
    subject     ['People']
    publisher   ['Rolling Stone Magazine']
    language    ['English']
  end
end

