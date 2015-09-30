require 'rails_helper'

describe Image do
  describe "indexer_class" do
    subject { described_class.indexer }
    it { is_expected.to eq ImageIndexer }
  end
end
