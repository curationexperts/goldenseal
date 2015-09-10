require 'rails_helper'

describe WorkShowPresenter do
  let(:presenter) { described_class.new(solr_doc, ability) }
  let(:ability) { nil }
  let(:solr_doc) { SolrDocument.new(attributes) }

  describe "tei_id" do
    let(:attributes) { { 'hasEncodedText_ssim' => ['1234'] } }
    subject { presenter.tei_id }
    it { is_expected.to eq '1234' }
  end
end
