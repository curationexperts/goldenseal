require 'rails_helper'

describe Collection do
  describe "human_readable_type" do
    subject { described_class.human_readable_type }
    it { is_expected.to eq 'Personal Collection' }
  end
end
