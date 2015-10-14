require 'rails_helper'

describe CurationConcerns::TextForm do
  let(:raw_attributes) { ActionController::Parameters.new(tei_id: '122') }

  describe ".model_attributes" do
    subject { described_class.model_attributes(raw_attributes) }

    it { is_expected.to eq('tei_id' => '122') }
  end
end
