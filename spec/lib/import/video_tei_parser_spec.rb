require 'rails_helper'
require 'import'

describe Import::VideoTeiParser do
  let(:add_tei) { File.join(fixture_path, 'tei', 'add14885.01250.032.xml') }

  describe 'initialize' do
    subject { described_class.new(add_tei) }

    it 'sets the file' do
      expect(subject.file).to eq add_tei
    end
  end

  describe '#attributes' do
    subject { parser.attributes }

    context 'when it successfully parses the file' do
      let(:parser) { described_class.new(add_tei) }

      it 'gets the attributes for the record from the TEI file' do
        expect(subject[:identifier]).to eq ['add14885.01250.032', 'MAVIS Interview Record: 1250']
        expect(subject[:title]).to eq ['Interview with Frank Addonizio', '[electronic resource]']
        expect(subject[:date_issued]).to eq '2014'
        expect(subject[:date_created]).to eq ['June 15, 1994']
        expect(subject[:creator]).to eq ['Blackside, Inc.']
        expect(subject[:contributor]).to eq ['Blackside, Inc.']
        expect(subject[:publisher]).to eq ['Washington University in St. Louis']
        expect(subject[:description]).to eq ["Interview gathered as part of America's War on Poverty . Produced by Blackside, Inc. Housed at the Washington University Film and Media Archive, Henry Hampton Collection."]
        expect(subject[:rights]).to eq ['Material is free to use for research purposes only. If researcher intends to use transcripts for publication, please contact Washington University’s Film and Media Archive for permission to republish. Please use preferred citation given in the transcript. © Copyright Washington University Libraries 2014']
        expect(subject[:language]).to eq ['English']
        expect(subject[:publication_place]).to eq ['St. Louis, Missouri']
        expect(subject[:subject]).to eq ["Addonizio, Frank", "War on Poverty", "Imperial, Tony", "Urban Renewal Committee", "Canine Corps", "Social movements — United States — History — 20th century.", "Poor -- United States.", "Economic assistance, Domestic -- United States.", "United States -- Social policy.", "United States -- Politics and government -- 1963-1969.", "Johnson, Lyndon B. (Lyndon Baines), 1908-1973.", "United States -- Politics and government -- 1963-1969.", "Johnson, Lyndon B. (Lyndon Baines), 1908-1973 -- Political and social views.", "Poverty -- Government policy -- United States -- History.", "United States -- Economic policy.", "Poverty -- United States.", "United States — Politics and government — 20th century.", "United States — Social conditions — 20th century.", "Political culture — United States — History — 20th century.", "United States — Economic conditions — 20th century.", "Oral history — United States.", "Interviews — United States.", "America's War on Poverty (Television program).", "Hampton, Henry, 1940-1998.", "Blackside, Inc.", "Riots.", "Racism.", "Public welfare -- United States.", "Newark (N.J.)"]
        expect(subject[:files]).to eq ['fma-2-78436-acc-20140424.mov']
      end
    end
  end
end
