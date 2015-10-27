require 'rails_helper'

describe AdminSet do
  describe "human_readable_type" do
    subject { described_class.human_readable_type }
    it { is_expected.to eq 'Administrative Collection' }
  end

  describe "#identifier" do
    subject { described_class.new(title: 'test') }

    it "must be routable" do
      subject.identifier = ''
      expect(subject).not_to be_valid
      subject.identifier = '12345.56.abcd'
      expect(subject).to be_valid
      subject.identifier = '12345-56_ABC'
      expect(subject).to be_valid
    end
  end
end
