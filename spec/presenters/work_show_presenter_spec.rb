require 'rails_helper'

describe WorkShowPresenter do
  let(:presenter) { described_class.new(solr_doc, ability) }
  let(:ability) { nil }
  let(:solr_doc) { SolrDocument.new(attributes) }
  let(:attributes) { {} }

  describe "#permission_badge_class" do
    subject { presenter.permission_badge_class }
    it { is_expected.to eq PermissionBadge }
  end

  describe "tei_id" do
    let(:attributes) { { 'hasTranscript_ssim' => ['1234'] } }
    subject { presenter.tei_id }
    it { is_expected.to eq '1234' }
  end

  describe "height" do
    let(:attributes) { { 'height_is' => 7777 } }
    subject { presenter.height }
    it { is_expected.to eq 7777 }
  end

  describe "width" do
    let(:attributes) { { 'width_is' => 888 } }
    subject { presenter.width }
    it { is_expected.to eq 888 }
  end

  describe "mime_type" do
    let(:attributes) { { 'mime_type_ssi' => 'image/jp2' } }
    subject { presenter.mime_type }
    it { is_expected.to eq 'image/jp2' }
  end

  describe "filename" do
    let(:attributes) { { 'label_ssi' => 'frog.png' } }
    subject { presenter.filename }
    it { is_expected.to eq 'frog.png' }
  end

  describe "#attribute_to_html" do
    let(:renderer) { double }
    context "in an admin_set" do
      let(:attributes) { { 'isPartOf_ssim' => ['123'], 'admin_set_ssi' => 'Title' } }
      it "calls the renderer" do
        expect(AdminSetRenderer).to receive(:new)
          .with(:admin_set, ['Title'], link_path: '/admin_sets/123')
          .and_return(renderer)

        expect(renderer).to receive(:render)
        presenter.attribute_to_html(:admin_set)
      end
    end

    context "not in an admin_set" do
      let(:attributes) { {} }
      it "doesn't calls the renderer" do
        expect(AdminSetRenderer).not_to receive(:new)
        presenter.attribute_to_html(:admin_set)
      end
    end
  end
end
