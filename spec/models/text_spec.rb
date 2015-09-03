require 'rails_helper'

describe Text do
  before { Text.find('ccr1815.00757.018').destroy(eradicate: true) if Text.exists?('ccr1815.00757.018') }

  context "with TEI" do
    let(:document) do
      Text.new(id: 'ccr1815.00757.018', title: ['test text']) do |t|
        t.apply_depositor_metadata('jcoyne')
      end
    end
    let(:file) { '/tei/ccr1815.00757.018.xml' }

    before do
      generic_file = GenericFile.new do |gf|
        gf.apply_depositor_metadata('jcoyne')
      end
      document.members << generic_file
      document.save!
      Hydra::Works::AddFileToGenericFile.call(generic_file, File.open(fixture_path + file), :original_file)
      # It's important that we set TEI afterwards, so that the file is directly contained by the work.
      document.update tei: generic_file
    end

    describe 'id_for_filename' do
      let(:conn) { ActiveFedora::SolrService.instance.conn }
      let(:record) { double(original_name: 'anoabo00-00001.jp2', read: 'some bytes', size: 10) }
      before do
        document.save(validate: false)
        conn.add(id: '1j92g7448', has_model_ssim: ['GenericFile'], generic_work_ids_ssim: [document.id], label_ssi: 'anoabo00-00001.jp2')
        conn.commit

      end

      it "returns the path of the file" do
        expect(document.id_for_filename('anoabo00-00001.jp2')).to eq '1j92g7448'
      end
    end
  end

  describe "#save" do
    context "when there is one attached file, but no TEI specified" do
      let(:document) do
        Text.new(id: 'ccr1815.00757.018', title: ['test text']) do |t|
          t.apply_depositor_metadata('jcoyne')
        end
      end

      let(:file) { '/tei/ccr1815.00757.018.xml' }
      let(:generic_file) do
        GenericFile.new do |gf|
          gf.apply_depositor_metadata('jcoyne')
        end
      end

      before do
        document.members << generic_file
        document.save!
        Hydra::Works::AddFileToGenericFile.call(generic_file, File.open(fixture_path + file), :original_file)
      end

      it "default the tei file to the first file" do
        expect(document.tei).to be_nil
        document.save!
        expect(document.reload.tei).to eq generic_file
      end
    end
  end
end