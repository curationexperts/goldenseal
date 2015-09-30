require 'rails_helper'

describe TextPresenter do
  let(:conn)          { ActiveFedora::SolrService.instance.conn }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:attributes)    { {} }
  let(:presenter)     { described_class.new(solr_document, nil) }

  describe "tei?" do
    subject { presenter.tei? }

    context "when the document has tei" do
      let(:attributes) { { tei_json_ss: " " } }
      it { is_expected.to be true }
    end

    context "when the document doesn't have tei" do
      it { is_expected.to be false }
    end
  end

  describe "tei_as_json" do
    subject { presenter.tei_as_json }
    context "when the document has tei" do
      let(:json) { double }
      let(:attributes) { { tei_json_ss: json } }

      it { is_expected.to eq json }
    end
  end
end
