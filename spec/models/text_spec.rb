require 'rails_helper'

require 'active_fedora/cleaner'

describe Text do
  before { Text.find('ccr1815.00757.018').destroy(eradicate: true) if Text.exists?('ccr1815.00757.018') }

  context "with TEI" do
    let(:document) { Text.new(id: 'ccr1815.00757.018') }
    subject { document }
    let(:file) { '/tei/ccr1815.00757.018.xml' }

    before do
      document.add_file(File.open(fixture_path + file).read, path: 'tei')
    end

    describe "tei?" do
      it { is_expected.to be_truthy }
    end


    describe 'tei_as_json' do
      subject { document.tei_as_json }

      context "without a titlePage with an image" do
        before do
          allow(document).to receive(:id_for_filename).and_return("0001")
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

    describe 'id_for_filename' do
      let(:conn) { ActiveFedora::SolrService.instance.conn }
      let(:record) { double(original_name: 'anoabo00-00001.jp2', read: 'some bytes', size: 10) }
      before do
        document.save(validate: false)
        conn.add(id: '1j92g7448', has_model_ssim: ['GenericFile'], generic_work_ids_ssim: [document.id], title_sim: ['anoabo00-00001.jp2'])
        conn.commit

      end
      # let!(:generic_file) do
      #   Worthwhile::GenericFile.new(batch_id: document.id).tap do |file|
      #     file.add_file(File.open(fixture_path + '/files/anoabo00-00001.jp2', 'rb').read, 'content', 'anoabo00-00001.jp2')
      #     file.apply_depositor_metadata('jmc')
      #     file.save!
      #   end
      # end
      it "returns the path of the file" do
        expect(document.id_for_filename('anoabo00-00001.jp2')).to eq '1j92g7448'
      end
    end
  end
end
