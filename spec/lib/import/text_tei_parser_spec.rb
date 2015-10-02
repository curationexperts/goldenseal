require 'rails_helper'
require 'import'

describe Import::TextTeiParser do
  let(:lewald_tei) { File.join(fixture_path, 'text_importer', 'sample_import_files', 'lew1864.0001.001.xml') }

  describe 'initialize' do
    subject { described_class.new(lewald_tei) }

    it 'sets the file' do
      expect(subject.file).to eq lewald_tei
    end
  end

  describe '#attributes' do
    subject { parser.attributes }

    context 'when it successfully parses the file' do
      let(:parser) { described_class.new(lewald_tei) }

      it 'gets the attributes for the record from the TEI file' do
        expect(subject[:identifier]).to eq ['lew1864.0001.001']
        expect(subject[:title]).to eq ['Der Letzte seines Stammes: Mamsell Philippinens Philipp']
        expect(subject[:creator]).to eq ['Fanny Lewald']
        expect(subject[:editor]).to eq ['Fanny Lewald']
        expect(subject[:publisher]).to eq ['Otto Janke']
        expect(subject[:language]).to eq ['German']
        expect(subject[:extent]).to eq ['1 novel in 1 volume']
        expect(subject[:rights]).to eq ['work is in the public domain']
        expect(subject[:date_issued]).to eq '1864'

        expect(subject[:files].first).to eq 'letz_01_0001_unm.jp2'
        expect(subject[:files].fourth).to eq 'letz_01_0004_003.jp2'
        expect(subject[:files].count).to eq 337
      end
    end

    context 'when some attributes are blank' do
      let(:unparseable_file) { File.join(fixture_path, 'text_importer', 'dir_with_xml_files', 'file1.xml') }
      let(:parser) { described_class.new(unparseable_file) }

      it 'clears out the blank values' do
        expect(subject).to eq({})
      end
    end
  end
end
