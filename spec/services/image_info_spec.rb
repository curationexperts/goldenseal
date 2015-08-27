require 'rails_helper'

describe ImageInfo do
  let(:conn) { ActiveFedora::SolrService.instance.conn }
  before do
    conn.add id: "1j92g7448", "height_is": 1754, "width_is": 2338
    conn.commit
  end

  describe "#dimensions" do
    subject { described_class.new('1j92g7448').dimensions }
    it { is_expected.to eq("height": 1754, "width": 2338) }
  end
end
