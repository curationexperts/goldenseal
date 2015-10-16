require 'rails_helper'

describe CurationConcerns::AudioForm do
  let(:raw_attributes) { ActionController::Parameters.new(tei_id: '122', editor: ['John']) }

  describe ".model_attributes" do
    subject { described_class.model_attributes(raw_attributes) }

    it { is_expected.to eq('tei_id' => '122', 'editor' => ['John']) }
  end
end
