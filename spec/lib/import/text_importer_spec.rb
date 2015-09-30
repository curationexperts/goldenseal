require 'rails_helper'
require 'import'

describe Import::TextImporter do
  let(:importer) { described_class.new(dir) }

  describe 'inititialize' do
    let(:dir) { File.join(fixture_path, 'tei') }
    subject { described_class.new(dir) }

    it 'sets the TEI directory' do
      expect(subject.tei_dir).to eq dir
    end
  end

  describe '#status' do
    let(:dir) { File.join(fixture_path, 'tei') }
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

  describe '#user' do
    let(:dir) { File.join(fixture_path, 'tei') }
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

  describe '#tei_files' do
    subject { importer.tei_files }

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

  describe '#parse_tei' do
    context "when the TEI file can't be parsed" do
      let(:dir) { File.join(fixture_path, 'text_importer', 'dir_with_xml_files') }
      let(:file) { File.join(dir, 'file1.xml') }

      it 'records an error message' do
        expect { importer.parse_tei(file) }.to change { Text.count }.by(0)

        expect(importer.errors).to eq ['Failed to parse TEI file: file1.xml']
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
        expect { importer.parse_tei(file) }.to change { Text.count }.by(0)
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
        expect { importer.parse_tei(file) }.to change { Text.count }.by(0)

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

    context 'when identifier field has more than one value' do
      let(:attrs) {{ identifier: ['id1', 'id2'],
                     title: ["Some Title"], files: [] }}

      it 'raises an error' do
        expect { subject }.to raise_error('Unable to determine identifier for record: ["id1", "id2"]')
      end
    end

    context 'when the record already exists' do
      let(:attrs) {{ identifier: ['id1'],
                     title: ["Some Title"], files: [] }}

      before do
        allow_any_instance_of(ActiveFedora::Relation).to receive(:where).with("identifier_tesim" => 'id1').and_return(['something'])
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
        allow_any_instance_of(ActiveFedora::Relation).to receive(:where).with("identifier_tesim" => 'id1').and_return(['something', 'two things'])
      end

      it 'raises an error' do
        expect { subject }.to raise_error('Too many matches found for record: id1')
      end
    end
  end

  describe '#create_file' do
    let(:dir) { File.join(fixture_path, 'text_importer', 'dir_with_xml_files') }
    let(:file) { File.join(dir, 'file1.xml') }

    subject { importer.create_file('123', file) }

    before do
      allow(CurationConcerns::GenericFileActor).to receive(:new).and_return(actor)
      allow(GenericFile).to receive(:new).and_return(gf)
    end

    context 'when the GenericFile has errors' do
      let(:actor) { double('actor', create_metadata: true, create_content: true) }
      let(:gf) { double('gf', errors: { base: 'base error', id: 'id error' }) }

      it 'raises an error' do
        expect { subject }.to raise_error('GenericFile had errors')
        expect(importer.errors).to include('GF base: base error')
        expect(importer.errors).to include('GF id: id error')
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

    context 'when the importer runs successfully' do
      let(:dir) { File.join(fixture_path, 'text_importer', 'sample_import_files') }

      before do
        # Stub out anything that requires a redis connection,
        # such as background jobs and lock management.
        allow(CharacterizeJob).to receive_messages(perform_later: nil, perform_now: nil)
        allow_any_instance_of(CurationConcerns::GenericFileActor).to receive(:acquire_lock_for).and_yield
      end

      it 'it creates a record for each TEI and attaches files to it' do
        expect { importer.run }
          .to(change { Text.count }.by(2)
          .and(change { GenericFile.count }.by(4)),
              lambda { importer.status.inspect })

        record = Text.where('identifier_tesim' => 'lew1864.0001.001').first
        expect(record.tei.label).to eq File.join('lew1864.0001.001.xml')

        # The first TEI file lists 337 files and the other TEI
        # lists 13, for a total of 350 files.  For this test,
        # we'll only attach 2 of the files, so we expect to
        # get warning messages for the remaining 348 files.
        expect(importer.warnings.count).to eq 348
        expect(importer.warnings).to include 'lew1864.0001.001.xml: File not found: letz_01_0002_ttl.jp2'

        expect(importer.errors.count).to eq 0
        expect(importer.successful_imports.sort).to eq ['ccr1821.00991.008.xml', 'lew1864.0001.001.xml']
        expect(importer.skipped_imports).to eq []
      end
    end
  end
end
