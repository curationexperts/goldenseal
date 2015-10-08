require 'rails_helper'

describe AdminSet do
  describe "human_readable_type" do
    subject { described_class.human_readable_type }
    it { is_expected.to eq 'Administrative Collection' }
  end
end
