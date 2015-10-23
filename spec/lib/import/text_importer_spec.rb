require 'rails_helper'
require 'import'

describe Import::TextImporter do
  let(:admin_set_id) { nil }
  let(:visibility) { nil }
  let(:dir) { File.join(fixture_path, 'tei') }

  let(:importer) { described_class.new(dir, { visibility: visibility, admin_set_id: admin_set_id }) }

  let(:pub_dom_url) { 'http://creativecommons.org/publicdomain/mark/1.0/' }

  describe 'inititialize' do
    context 'when visibility is not given' do
      subject { described_class.new(dir) }

      it 'sets the TEI directory and default visibility' do
        expect(subject.root_dir).to eq dir
        expect(subject.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PRIVATE
      end
    end

    context 'when visibility and admin_set_id are given' do
      let(:visibility) { 'open' }
      let(:admin_set_id) { '123' }
      subject { importer }

      it 'initializes the instance variables' do
        expect(subject.root_dir).to eq dir
        expect(subject.visibility).to eq Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC
        expect(subject.admin_set_id).to eq admin_set_id
      end
    end
  end

  describe '#status' do
    subject { described_class.new(dir) }

    it 'keeps track of the status of the importer' do
      expect(subject.errors).to eq []
      expect(subject.warnings).to eq []
      expect(subject.successful_imports).to eq []
      expect(subject.skipped_imports).to eq []
      expect(subject.status.is_a?(Import::ImportResults)).to be true
    end

    it 'allows you to add status messages' do
      subject.errors << 'error message 1'
      expect(subject.errors).to eq ['error message 1']
    end
  end

  describe '#admin_set' do
    context 'when admin_set_id is empty' do
      subject { described_class.new(dir) }

      it 'returns nil' do
        expect(subject.admin_set).to be_nil
      end
    end

    context 'for an existing AdminSet' do
      let!(:set) { create(:admin_set) }
      let(:admin_set_id) { set.id }

      it 'sets the admin_set' do
        expect(importer.admin_set).to eq set
      end
    end

    context "when the AdminSet doesn't exist" do
      let(:admin_set_id) { 'some_bad_ID' }

      it 'records an error' do
        expect(importer.admin_set).to be_nil
        expect(importer.errors.first).to match /Unable to find AdminSet: #{admin_set_id}/
      end
    end
  end

  describe '#user' do
    subject { described_class.new(dir).user }

    context 'when user already exists' do
      let!(:existing_user) { User.create!(username: 'system') }

      it 'returns the existing user' do
        expect(subject).to eq existing_user
      end
    end

    context "when the user doesn't exist yet" do
      before { User.delete_all }

      it 'creates the user' do
        expect { subject }.to change { User.count }.by(1)
        expect(subject.user_key).to eq 'system'
        expect(subject.persisted?).to be true
      end
    end
  end

  describe '#metadata_files' do
    subject { importer.metadata_files }

    context "when the directory can't be found" do
      let(:dir) { File.join(fixture_path, 'some_bad_path') }

      it 'raises an error' do
        expect { subject }.to raise_error("Directory not found: #{dir}")
      end
    end

    context "when the directory contains no TEI files" do
      let(:dir) { File.join(fixture_path, 'text_importer', 'dir_with_no_xml_files') }

      it 'returns an empty list' do
        expect(subject).to eq []
      end
    end

    context 'when the directory and files are correct' do
      let(:dir) { File.join(fixture_path, 'text_importer', 'dir_with_xml_files') }

      it 'returns a list of the xml files' do
        expect(subject.sort).to eq ["#{dir}/file1.xml", "#{dir}/file2.xml"]
      end
    end
  end

  describe '#parse_metadata' do
    context "when the TEI file can't be parsed" do
      let(:dir) { File.join(fixture_path, 'text_importer', 'dir_with_xml_files') }
      let(:file) { File.join(dir, 'file1.xml') }

      it 'records an error message' do
        expect { importer.parse_metadata(file) }.to change { Text.count }.by(0)

        expect(importer.errors).to eq ['Failed to parse file: file1.xml']
        expect(importer.warnings).to eq []
        expect(importer.successful_imports).to eq []
        expect(importer.skipped_imports).to eq []
      end
    end

    context 'when the importer is unable to create a record' do
      before { ActiveFedora::Cleaner.clean! }

      let(:dir) { File.join(fixture_path, 'text_importer', 'sample_import_files') }
      let(:file) { File.join(dir, 'lew1864.0001.001.xml') }

      before do
        allow(importer).to receive(:create_record).and_raise('Some kind of error')
      end

      it 'adds an error message' do
        expect { importer.parse_metadata(file) }.to change { Text.count }.by(0)
        expect(importer.errors).to eq ["lew1864.0001.001.xml: Some kind of error"]
        expect(importer.successful_imports).to eq []
      end
    end

    context 'when the record already exists' do
      let(:dir) { File.join(fixture_path, 'text_importer', 'sample_import_files') }
      let(:file) { File.join(dir, 'lew1864.0001.001.xml') }

      before do
        allow(importer).to receive(:record_exists?).and_return(true)
      end

      it "doesn't import the record, marks it as skipped" do
        expect { importer.parse_metadata(file) }.to change { Text.count }.by(0)

        expect(importer.errors).to eq []
        expect(importer.warnings).to eq []
        expect(importer.successful_imports).to eq []
        expect(importer.skipped_imports).to eq ['lew1864.0001.001.xml']
      end
    end
  end

  describe '#record_exists?' do
    let(:dir) { File.join(fixture_path, 'text_importer', 'sample_import_files') }
    subject { importer.record_exists?(attrs) }

    context 'when identifier field is missing' do
      let(:attrs) { { title: ["Some Title"], files: [] } }
      it { is_expected.to be_falsey }
    end

    context 'when identifier field is empty' do
      let(:attrs) { { identifier: [], title: ["Some Title"], files: [] } }
      it { is_expected.to be_falsey }
    end

    context 'when the record already exists' do
      let(:attrs) {{ identifier: ['id1'],
                     title: ["Some Title"], files: [] }}

      before do
        allow_any_instance_of(ActiveFedora::Relation).to receive(:where).with("identifier_tesim" => ['id1']).and_return(['something'])
      end

      it { is_expected.to be_truthy }
    end

    context "when the record doesn't exist" do
      let(:attrs) {{ identifier: ['id1'],
                     title: ["Some Title"], files: [] }}
      it { is_expected.to be_falsey }
    end

    context 'when more than one matching record exists' do
      let(:attrs) {{ identifier: ['id1'],
                     title: ["Some Title"], files: [] }}

      before do
        allow_any_instance_of(ActiveFedora::Relation).to receive(:where).with("identifier_tesim" => ['id1']).and_return(['something', 'two things'])
      end

      it 'raises an error' do
        expect { subject }.to raise_error('Too many matches found for record: ["id1"]')
      end
    end
  end

  describe '#create_file' do
    let(:dir) { File.join(fixture_path, 'text_importer', 'dir_with_xml_files') }
    let(:file) { File.join(dir, 'file1.xml') }
    let(:record) { double('text record', id: '123') }

    subject { importer.create_file(record, file) }

    before do
      allow(CurationConcerns::FileSetActor).to receive(:new).and_return(actor)
      allow(FileSet).to receive(:new).and_return(gf)
    end

    context 'when the FileSet has errors' do
      let(:actor) { double('actor', create_metadata: true, create_content: true) }
      let(:gf) { double('gf', errors: { base: 'base error', id: 'id error' }) }

      it 'raises an error' do
        expect { subject }.to raise_error('FileSet had errors')
        expect(importer.errors).to include('FileSet base: base error')
        expect(importer.errors).to include('FileSet id: id error')
      end
    end

    context 'when the content creation fails' do
      let(:actor) { double('actor', create_metadata: true, create_content: false) }
      let(:gf) { double('gf', errors: {}) }

      it 'raises an error' do
        expect { subject }.to raise_error('Content creation failed')
      end
    end
  end


  describe '#run' do
    before { ActiveFedora::Cleaner.clean! }

    let(:dir) { File.join(fixture_path, 'text_importer', 'sample_import_files') }
    let(:visibility) { Hydra::AccessControls::AccessRight::VISIBILITY_TEXT_VALUE_PUBLIC }

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
