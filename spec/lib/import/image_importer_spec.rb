require 'rails_helper'
require 'import'

describe Import::ImageImporter do
  let(:admin_set_id) { nil }
  let(:visibility) { nil }
  let(:dir) { File.join(fixture_path, 'image_importer') }

  let(:importer) { described_class.new(dir, { visibility: visibility, admin_set_id: admin_set_id }) }

  describe '#run' do
    before { ActiveFedora::Cleaner.clean! }

    context 'when the importer runs successfully' do
      before { stub_out_redis }

      it 'it creates a record for each VRA and attaches files to it' do
        expect { importer.run }
          .to(change { Image.count }.by(1)
          .and(change { FileSet.count }.by(2)),
          lambda { importer.status.inspect }) # if this spec fails, print importer status so that we can see errors

        record = Image.first
        rep = FileSet.find(record.representative_id)
        expect(rep.label).to eq 'bull_ru_ku_001_015_0015.jp2'

        expect(importer.errors).to eq []
        expect(importer.warnings).to eq []
        expect(importer.successful_imports.sort).to eq ['wtu00001_015.xml']
        expect(importer.skipped_imports).to eq []
      end
    end
  end
end
