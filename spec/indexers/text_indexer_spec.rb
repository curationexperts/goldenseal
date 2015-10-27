require 'rails_helper'

describe TextIndexer do
  let(:indexer) { described_class.new(text) }

  let(:text) do
    Text.new(title: ['test text']) do |t|
      t.apply_depositor_metadata('jcoyne')
    end
  end

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }
    before do
      allow(text).to receive(:member_ids).and_return(['23', '24'])
    end

    it "has member_ids" do
      expect(subject.fetch('member_ids_ssim')).to eq ['23', '24']
    end
  end
end
