require 'rails_helper'

describe TextPresenter do
  let(:conn)          { ActiveFedora::SolrService.instance.conn }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:attributes)    { {} }
  let(:presenter)     { described_class.new(solr_document, nil) }

  describe "tei?" do
    before do
      allow(presenter).to receive(:tei_as_json).and_return(result)
    end
    subject { presenter.tei? }

    context "when the document has tei" do
      let(:result) { 'something' }
      it { is_expected.to be true }
    end

    context "when the document doesn't have tei" do
      let(:result) { nil }
      it { is_expected.to be false }
    end
  end

  describe "tei_as_json" do
    let(:result) { double }
    let(:service) { double(to_json: result) }
    subject { presenter.tei_as_json }
    let(:text) { double }
    before do
      allow(solr_document).to receive(:to_model).and_return(text)
      allow(TeiForText).to receive(:new).with(text).and_return(service)
    end
    it "calls TeiForText with the text" do
      expect(subject).to eq result
    end
  end

  describe "tei_id" do
    let(:attributes) { { 'hasTranscript_ssim' => ['1234'] } }
    subject { presenter.tei_id }
    it { is_expected.to eq '1234' }
  end
end
