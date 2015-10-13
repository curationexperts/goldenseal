require 'rails_helper'

describe ImageIndexer do
  let(:indexer) { described_class.new(image) }

  let(:image) do
    Image.new(title: ['test text'], representative_id: '12345') do |t|
      t.apply_depositor_metadata('jcoyne')
    end
  end

  describe "#generate_solr_document" do
    before do
      allow(ImageInfo).to receive(:new).with('12345').and_return(info)
    end

    let(:info) { double(solr_document: { "height_is" => 1754, "width_is" => 2338 }) }
    subject { indexer.generate_solr_document }

    it "has height and width" do
      expect(subject.fetch('height_is')).to eq 1754
      expect(subject.fetch('width_is')).to eq 2338
    end
  end
end
