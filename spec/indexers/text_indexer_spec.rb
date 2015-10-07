require 'rails_helper'

describe TextIndexer do
  let(:indexer) { described_class.new(text) }
  before do
    Text.find('ccr1815.00757.018').destroy(eradicate: true) if Text.exists?('ccr1815.00757.018')
  end

  let(:text) do
    Text.new(id: 'ccr1815.00757.018', title: ['test text']) do |t|
      t.apply_depositor_metadata('jcoyne')
    end
  end

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }
    let(:json) { { pages: ['1', '2'] } }
    before do
      allow(text).to receive(:tei).and_return(double)
      allow(text).to receive(:member_ids).and_return(['23', '24'])
      allow(indexer).to receive(:tei_as_json).and_return(json)
    end

    it "has tei json" do
      expect(subject.fetch('tei_json_ss')).to eq "{\"pages\":[\"1\",\"2\"]}"
    end

    it "has file_set_ids" do
      expect(subject.fetch('file_set_ids_ssim')).to eq ['23', '24']
    end
  end

  describe 'tei_as_json' do
    subject { indexer.tei_as_json }

    let(:file) { '/tei/ccr1815.00757.018.xml' }

    let(:file_set) do
      FileSet.new do |gf|
        gf.apply_depositor_metadata('jcoyne')
      end
    end

    before do
      text.members << file_set
      text.save!
    end

    context "with a file" do
      before do
        Hydra::Works::AddFileToFileSet.call(file_set, File.open(fixture_path + file), :original_file)
        # It's important that we set TEI afterwards, so that the file is directly contained by the work.
        text.update tei: file_set
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

    context "when the original_file is missing" do
      before do
        text.update tei: file_set
      end
      it "returns nothing" do
        expect(subject).to be_nil
      end
    end
  end
end
