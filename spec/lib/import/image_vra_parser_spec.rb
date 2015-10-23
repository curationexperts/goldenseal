require 'rails_helper'
require 'import'

describe Import::ImageVraParser do
  let(:vra) { File.join(fixture_path, 'image_importer', 'wtu00001_015.xml') }
  let(:parser) { described_class.new(vra) }

  describe 'initialize' do
    subject { parser }

    it 'sets the file' do
      expect(subject.file).to eq vra
    end
  end

  describe '#attributes' do
    subject { parser.attributes }

    context 'when it successfully parses the file' do
      it 'gets the attributes for the image from the VRA file' do
        expect(subject[:title]).to eq ['15.Battle of Bull Run']
        expect(subject[:description]).to eq ['Battle Scenes. Consists of 36 chromolithographs, 1 facsimile. Arranged in battle order by James E. Schiele.']
        expect(subject[:contributor]).to eq ['James E. Schiele', 'Joan Singer Schiele']
        expect(subject[:publisher]).to eq ['University Libraries, Washington University in St.Louis, Department of Special Collections, Olin Library']
        expect(subject[:extent]).to eq ['30-1/8 x 23-3/8 inches,matted. 1 print.']
      end
    end
  end

end
