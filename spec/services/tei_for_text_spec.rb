require 'rails_helper'

describe TeiForText do
  let(:service) { described_class.new(text) }
  let(:text) { Text.create(title: ['foo']) { |t| t.apply_depositor_metadata 'jcoyne' } }

  describe "to_json" do

    context "without tei" do
      subject { service.to_json }
      it { is_expected.to be nil }
    end

    context "when the text has tei" do
      subject { JSON.parse(service.to_json) }
      let(:file) { '/tei/ccr1815.00757.018.xml' }
      let(:file_set) { FileSet.new { |gf| gf.apply_depositor_metadata('jcoyne') } }

      before do
        Hydra::Works::AddFileToFileSet.call(file_set, File.open(fixture_path + file), :original_file)
        text.ordered_members << file_set
        text.save!
        # It's important that we set TEI afterwards, so that the file is directly contained by the work.
        text.update tei: file_set
        allow(text).to receive(:id_for_filename).and_return("0001")
      end

      it "has the json" do
        expect(subject).to be_kind_of Hash
        expect(subject['pages'].size).to eq 26
        # expect(subject['pages'].first['html']).to be_html_safe
        expect(subject['pages'].first['image']).to eq '<img src="/image-service/0001/full/,600/0/native.jpg" alt="Native" />'
      end

      context "with errors" do
        before do
          allow_any_instance_of(Nokogiri::HTML::Document).to receive(:css).with('#tei-content').and_return([])
        end

        it "draws an error" do
          expect(subject).to eq("error" => "Unable to parse TEI for this object.")
        end
      end
    end
  end
end
