FactoryGirl.define do
  factory :image do
    transient do
      depositor { 'Frodo' }
    end

    before(:create) do |image, evaluator|
      image.apply_depositor_metadata(evaluator.depositor)
    end

    trait :public do
      visibility Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
    end
  end
end
