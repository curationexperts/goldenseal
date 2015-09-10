FactoryGirl.define do
  factory :generic_file do
    transient do
      depositor "archivist1@example.com"
    end
    after(:build) do |gf, evaluator|
      gf.apply_depositor_metadata evaluator.depositor
    end

    title ["Test title"]

    factory :tei_bearing_file do
      transient do
        filename "spec/fixtures/tei/add14885.01250.032.xml"
      end
      after(:create) do |gf, evaluator|
        Hydra::Works::AddFileToGenericFile.call(gf, File.open(evaluator.filename), :original_file)
      end
    end
  end

end

