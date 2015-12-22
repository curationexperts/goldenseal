require 'rails_helper'

describe ApplicationHelper do
  describe "#index_description" do
    let(:config) { Blacklight::Configuration::IndexField.new(length: 25) }
    let(:document) { double("solr document", to_model: model) }
    let(:model) { double("the model", persisted?: true, model_name: Image.model_name, to_param: '1234') }
    before do
      allow(helper).to receive(:blacklight_config).and_return(CatalogController.blacklight_config)
    end
    subject { helper.index_description(config: config, document: document, value: value) }

    context "with a short value" do
      let(:value) { ['This is short'] }
      it { is_expected.to eq 'This is short' }
    end

    context "with a long value" do
      let(:value) { ['This is long. So very very very long.'] }
      it { is_expected.to eq 'This is long. So very...<a href="/concern/images/1234">Show full record</a>' }
    end
  end
end
