require 'rails_helper'

describe Text do
  before { Text.find('ccr1815.00757.018').destroy(eradicate: true) if Text.exists?('ccr1815.00757.018') }

  context "with TEI" do
    let(:document) { Text.new(id: 'ccr1815.00757.018') }
    subject { document }
    let(:file) { '/tei/ccr1815.00757.018.xml' }

    before do
      document.add_file(File.open(fixture_path + file).read, path: 'tei')
    end

    describe 'id_for_filename' do
      let(:conn) { ActiveFedora::SolrService.instance.conn }
      let(:record) { double(original_name: 'anoabo00-00001.jp2', read: 'some bytes', size: 10) }
      before do
        document.save(validate: false)
        conn.add(id: '1j92g7448', has_model_ssim: ['GenericFile'], generic_work_ids_ssim: [document.id], title_sim: ['anoabo00-00001.jp2'])
        conn.commit

      end

      it "returns the path of the file" do
        expect(document.id_for_filename('anoabo00-00001.jp2')).to eq '1j92g7448'
      end
    end
  end
end
