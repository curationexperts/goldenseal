require 'rails_helper'

describe ImageInfo do
  let(:conn) { ActiveFedora::SolrService.instance.conn }
  before do
    # TODO mime_type field is changing: https://github.com/curationexperts/goldenseal/issues/138
    conn.add id: "1j92g7448", height_is: 1754, width_is: 2338, mime_type_tesim: ['image/png'], label_ssi: 'foo.png'
    conn.commit
  end

  let(:service) { described_class.new('1j92g7448') }

  describe "#dimensions" do
    subject { service.dimensions }
    it { is_expected.to eq(height: 1754, width: 2338) }
  end

  describe "#solr_document" do
    subject { service.solr_document }
    it { is_expected.to eq("height_is" => 1754, "width_is" => 2338, 'mime_type_tesim' => ['image/png'], 'label_ssi' => 'foo.png') }
  end
end
