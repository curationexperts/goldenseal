require 'rails_helper'

describe SearchBuilder do
  let(:context) { double }
  let(:builder) { SearchBuilder.new(true, context) }

  describe "collection_clauses" do
    subject { builder.collection_clauses }

    it { is_expected.to eq ["{!terms f=has_model_ssim}Collection,AdminSet"] }
  end
end
