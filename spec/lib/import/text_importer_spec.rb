require 'rails_helper'
require 'import'

describe Import::TextImporter do
  let(:admin_set_id) { nil }
  let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }
  let(:dir) { File.join(fixture_path, 'text_importer', 'sample_import_files') }

  let(:importer) { described_class.new(dir, { visibility: visibility, admin_set_id: admin_set_id }) }

  let(:pub_dom_url) { 'http://creativecommons.org/publicdomain/mark/1.0/' }


  describe '#run' do
    before { ActiveFedora::Cleaner.clean! }

    context 'when the importer runs successfully' do
      let!(:set) { create(:admin_set) }
      let(:admin_set_id) { set.id }

      before { stub_out_redis }

      it 'it creates a record for each TEI and attaches files to it' do
        expect { importer.run }
          .to(change { Text.count }.by(2)
          .and(change { FileSet.count }.by(4)),
          lambda { importer.status.inspect }) # if this spec fails, print importer status so that we can see errors

        record = Text.where('identifier_tesim' => 'lew1864.0001.001').first
        expect(record.tei.label).to eq 'lew1864.0001.001.xml'
        expect(record.visibility).to eq visibility
        expect(record.rights).to eq [pub_dom_url]
        expect(FileSet.all.map(&:visibility).uniq).to eq [visibility]

        # Set the representative and thumbnail to the first page of the book
        rep = FileSet.find(record.representative_id)
        expect(rep.label).to eq 'letz_01_0001_unm.jp2'
        expect(rep.generic_work_ids).to eq [record.id]
        expect(record.thumbnail_id).to eq rep.id

        # The new record should belong to the AdminSet
        expect(record.admin_set).to eq set

        # The first TEI file lists 337 files, but has 5
        # duplicate entries (0991_003.jp2 and 0991_004.jp2),
        # and the other TEI lists 13, for a total of 345 files.
        # For this test we'll only attach 2 of the files, so we
        # expect to get warning messages for the remaining 343
        # files.
        expect(importer.warnings.count).to eq 343
        expect(importer.warnings).to include 'lew1864.0001.001.xml: File not found: letz_01_0002_ttl.jp2'

        expect(importer.errors.count).to eq 0
        expect(importer.successful_imports.sort).to eq ['ccr1821.00991.008.xml', 'lew1864.0001.001.xml']
        expect(importer.skipped_imports).to eq []
      end
    end
  end
end
