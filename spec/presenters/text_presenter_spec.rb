require 'rails_helper'

describe TextPresenter do
  let(:conn)          { ActiveFedora::SolrService.instance.conn }
  let(:solr_document) { SolrDocument.new(attributes) }
  let(:attributes)    { {} }
  let(:presenter)     { described_class.new(solr_document, nil) }

  describe "tei?" do
    let(:service) { double(to_json: result) }
    subject { presenter.tei? }
    let(:text) { double }
    before do
      allow(solr_document).to receive(:to_model).and_return(text)
      allow(TeiForText).to receive(:new).with(text).and_return(service)
    end
    context "when document has tei" do
      let(:result) { double }
      it "is true" do
        expect(subject).to eq true
      end
    end
    context "when document does not have tei" do
      let(:result) { nil }
      it "is false" do
        expect(subject).to eq false
      end
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
