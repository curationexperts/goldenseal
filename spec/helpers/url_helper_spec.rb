require 'rails_helper'

describe CurationConcernsHelper do
  let(:solr_doc) { SolrDocument.new(attributes) }
  describe "url_for_document" do
    let(:attributes) { { 'id' => '123', 'has_model_ssim' => ['AdminSet'] } }
    subject { helper.url_for_document(solr_doc) }

    it { is_expected.to eq admin_set_path('123') }

  end
end
