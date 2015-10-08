require 'rails_helper'

describe AdminSetIndexer do
  let(:indexer) { described_class.new(admin_set) }
  let(:admin_set) { build(:admin_set) }

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }

    it "has generic type" do
      expect(subject.fetch('generic_type_sim')).to eq ["Collection"]
    end
  end
end
