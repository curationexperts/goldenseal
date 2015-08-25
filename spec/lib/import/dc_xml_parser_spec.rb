require 'rails_helper'
require 'import'

describe Import::DcXmlParser do
  let(:lew_file) { File.join(fixture_path, 'dlxs', 'short-lew-dc.xml') }

  describe 'inititialize' do
    subject { described_class.new(lew_file) }

    it 'sets the file' do
      expect(subject.file).to eq lew_file
    end
  end


  describe '#records' do
    subject { described_class.new(lew_file).records }

    it 'returns attributes for the records' do
      expect(subject.map{|r| r[:id]}).to eq ['lew1873.0001.003', 'lew1880.0001.008']
    end
  end


  describe '#attributes_for_record' do
    let(:parser) { described_class.new(lew_file) }
    subject { parser.attributes_for_record(node) }
    let(:node) { sample_record_node.root }

    it 'collects the attributes for the record' do
      expect(subject[:id]).to eq 'lew1864.0001.001'
      expect(subject[:identifier]).to eq ['oai::lew1864.0001.001']
      expect(subject[:title]).to eq ['Title 1', 'Title 2']
      expect(subject[:source]).to eq ["Der Letzte seines Stammes: Mamsell Philippinens Philipp\n      Fanny Lewald\n      Otto Janke\n      Berlin,Germany\n      1864"]
      expect(subject[:creator]).to eq ['Fanny Lewald']
      expect(subject[:publisher]).to eq ['Berlin,Germany: Otto Janke']
      expect(subject[:description]).to eq ['Description Text']
      expect(subject[:subject]).to eq ['Depressions — 1929 — United States — History.', 'Saint Louis (Mo.) -- Maps.']
      expect(subject[:language]).to eq ['German']
    end
  end

end


def sample_record_node
  Nokogiri::XML(<<-END_XML)
<record>

<header>
  <identifier>oai::lew1864.0001.001</identifier>
  <setSpec>lew</setSpec>
</header>

<metadata>
  <oai_dc:dc xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/oai_dc/ http://www.openarchives.org/OAI/2.0/oai_dc.xsd">
    <dc:title> Title 1 </dc:title>
    <dc:title> Title 2 </dc:title>
    <dc:source>Der Letzte seines Stammes: Mamsell Philippinens Philipp
      Fanny Lewald
      Otto Janke
      Berlin,Germany
      1864
    </dc:source>
    <dc:creator>Fanny Lewald</dc:creator>
    <dc:publisher>Berlin,Germany: Otto Janke</dc:publisher>
    <dc:date>1864</dc:date>
    <dc:description> Description Text </dc:description>
    <dc:identifier>http://digital.wustl.edu/cgi/t/text/text-idx?c=lew;cc=lew;rgn=full%20text;view=toc;idno=lew1864.0001.001</dc:identifier>
    <dc:identifier>http://digital.wustl.edu/l/lew/graphics/lew-thumb.gif</dc:identifier>
    <dc:language>German</dc:language>
    <dc:subject>Depressions — 1929 — United States — History.</dc:subject>
    <dc:subject>Saint Louis (Mo.) -- Maps.</dc:subject>
    <dc:rights>work is in the public domain</dc:rights>
  </oai_dc:dc>
</metadata>

</record>
  END_XML
end
