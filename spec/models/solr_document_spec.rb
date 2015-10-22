require 'rails_helper'

describe SolrDocument do
  let(:solr_doc) { SolrDocument.new(attributes) }

  describe "on_campus?" do
    subject { solr_doc.on_campus? }
    context "when restricted to on campus" do
      let(:attributes) { { Hydra.config.permissions.read.group => [OnCampusAccess::OnCampus] } }
      it { is_expected.to be true }
    end

    context "when not restricted to on campus" do
      let(:attributes) { { Hydra.config.permissions.read.group => ['public'] } }
      it { is_expected.to be false }
    end
  end
end
