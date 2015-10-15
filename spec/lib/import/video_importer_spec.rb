require 'rails_helper'
require 'import'

describe Import::VideoImporter do
  let(:vis_public) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }

  let(:admin_set_id) { nil }
  let(:visibility) { nil }
  let(:dir) { File.join(fixture_path, 'tei') }

  let(:importer) { described_class.new(dir, { visibility: visibility, admin_set_id: admin_set_id }) }

  describe 'inititialize' do
    let(:subject) { importer }
    let(:admin_set_id) { '123' }
    let(:visibility) { vis_public }

    it 'sets the instance variables' do
      expect(subject.root_dir).to eq dir
      expect(subject.visibility).to eq vis_public
      expect(subject.admin_set_id).to eq admin_set_id
    end
  end

  describe '#status' do
    let(:subject) { importer }

    it 'keeps track of the status of the importer' do
      expect(subject.errors).to eq []
      expect(subject.warnings).to eq []
      expect(subject.successful_imports).to eq []
      expect(subject.skipped_imports).to eq []
      expect(subject.status.is_a?(Import::ImportResults)).to be true
    end
  end

  describe '#run' do
    before { ActiveFedora::Cleaner.clean! }

    let(:dir) { File.join(fixture_path, 'video_importer') }
    let(:visibility) { vis_public }

    context 'when there is a problem with the AdminSet' do
      let(:admin_set_id) { 'some_bad_ID' }

      it 'aborts without trying to import anything' do
        expect(importer).not_to receive(:parse_metadata)
        expect { importer.run }.to change { Text.count }.by(0)
      end
    end

    context 'when the importer runs successfully' do
      let!(:set) { create(:admin_set) }
      let(:admin_set_id) { set.id }

      before { stub_out_redis }

      it 'it creates a record for each TEI and attaches files to it' do
        expect { importer.run }
          .to(change { Video.count }.by(1),
          lambda { importer.status.inspect })

        record = Video.first
        expect(record.tei.label).to eq 'add14885.01250.032.xml'
        expect(record.visibility).to eq visibility

        # The new record should belong to the AdminSet
        expect(record.admin_set).to eq set

        expect(importer.warnings).to eq []
        expect(importer.errors).to eq []
        expect(importer.skipped_imports).to eq []
        expect(importer.successful_imports).to eq ['add14885.01250.032.xml']
      end
    end
  end
end
