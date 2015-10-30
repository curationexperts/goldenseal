require 'rails_helper'

describe Text do
  before { described_class.find('ccr1815.00757.018').destroy(eradicate: true) if described_class.exists?('ccr1815.00757.018') }

  context "#id_for_filename" do
    let(:document) do
      described_class.new(id: 'ccr1815.00757.018', title: ['test text']) do |t|
        t.apply_depositor_metadata('jcoyne')
      end
    end
    let(:file_path) { '/tei/ccr1815.00757.018.xml' }
    let(:file) { File.open(fixture_path + file_path) }
    let(:file_set) do
      # CurationConcerns::FileSetActor#create_content set's the label in the wild
      FileSet.new(label: File.basename(file_path)) do |gf|
        gf.apply_depositor_metadata('jcoyne')
      end
    end

    before do
      document.ordered_members << file_set
      Hydra::Works::AddFileToFileSet.call(file_set, file, :original_file)
      document.save!
    end

    it "returns the path of the file" do
      expect(document.id_for_filename('ccr1815.00757.018.xml')).to eq file_set.id
    end
  end

  describe "#save" do
    context "when there is one attached file, but no TEI specified" do
      let(:document) do
        described_class.new(id: 'ccr1815.00757.018', title: ['test text']) do |t|
          t.apply_depositor_metadata('jcoyne')
        end
      end

      let(:file) { '/tei/ccr1815.00757.018.xml' }
      let(:file_set) do
        FileSet.new(mime_type: 'text/xml') do |gf|
          gf.apply_depositor_metadata('jcoyne')
        end
      end

      before do
        document.ordered_members << file_set
      end

      it "default the tei file to the first file" do
        expect(document.tei).to be_nil
        document.save!
        expect(document.reload.tei).to eq file_set
      end
    end
  end
end
