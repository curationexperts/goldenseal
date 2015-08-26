require 'rails_helper'

describe TextIndexer do
  let(:indexer) { described_class.new(text) }
  before do
    Text.find('ccr1815.00757.018').destroy(eradicate: true) if Text.exists?('ccr1815.00757.018')
  end

  let(:text) { Text.new(id: 'ccr1815.00757.018') }

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }
    let(:json) { double }
    before do
      allow(indexer).to receive(:tei_as_json).and_return(json)
    end

    it "has tei json" do
      expect(subject.fetch('tei_json_ss')).to eq json
    end
  end

  describe 'tei_as_json' do
    subject { indexer.tei_as_json }

    let(:file) { '/tei/ccr1815.00757.018.xml' }

    before do
      text.add_file(File.open(fixture_path + file).read, path: 'tei')
    end

    context "without a titlePage with an image" do
      before do
        allow(text).to receive(:id_for_filename).and_return("0001")
      end
      it "has 25 rows" do
        expect(subject).to be_kind_of Hash
        expect(subject['pages'].size).to eq 26
        expect(subject['pages'].first['html']).to be_html_safe
        expect(subject['pages'].first['image']).to eq '<img src="/image-service/0001/full/,600/0/native.jpg" alt="Native" />'
      end
    end

    context "with errors" do
      before do
        allow_any_instance_of(Nokogiri::HTML::Document).to receive(:css).with('#tei-content').and_return([])
      end

      it "draws an error" do
        expect(subject).to eq(error: "Unable to parse TEI for this object.")
      end
    end
  end
end
