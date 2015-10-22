require 'rails_helper'
require 'import'

describe Import::AudioImporter do
  let(:admin_set_id) { nil }
  let(:visibility) { nil }

  # TODO: This TEI is really for a Video, not Audio.  Find a sample of an Audio TEI.
  let(:dir) { File.join(fixture_path, 'video_importer') }

  let(:importer) { described_class.new(dir, { visibility: visibility, admin_set_id: admin_set_id }) }

  describe '#run' do
    before { ActiveFedora::Cleaner.clean! }

    context 'when the importer runs successfully' do
      before { stub_out_redis }

      it 'it creates a record for each TEI and attaches files to it' do
        expect { importer.run }
          .to(change { Audio.count }.by(1),
          lambda { importer.status.inspect })

        record = Audio.first
        expect(record.tei.label).to eq 'add14885.01250.032.xml'

        expect(importer.warnings).to eq []
        expect(importer.errors).to eq []
        expect(importer.skipped_imports).to eq []
        expect(importer.successful_imports).to eq ['add14885.01250.032.xml']
      end
    end
  end
end
