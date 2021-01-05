require 'rails_helper'

describe BlacklightConfigurationHelper do
  describe "#search_fields" do
    let(:blacklight_config) { CatalogController.blacklight_config }
    before do
      allow(helper).to receive_messages(blacklight_config: blacklight_config)
    end

    subject { helper.search_fields }
    it { is_expected.to eq [["All Fields", "all_fields"], ["Title", "title"], ["Creator", "creator"], ["Description", "description"], ["Content", "tei_json"], ["Identifier", "identifier"], ["Subject", "subject"]] }
  end
end
