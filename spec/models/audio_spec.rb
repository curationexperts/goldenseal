require 'rails_helper'

describe Audio do
  let(:document) { described_class.new }

  describe "tei" do
    subject { document.tei }
    it { is_expected.to be_nil }
  end

  describe "visibility" do
    before do
      document.read_groups = ['on-campus']
    end

    subject { document.visibility }
    it { is_expected.to eq 'on-campus' }
  end

  describe "visibility=" do
    context "from open" do
      before do
        document.visibility = 'open'
      end

      it "changes to on-campus" do
        document.visibility = 'on-campus'
        expect(document.read_groups).to eq ['on-campus']
      end
    end

    context "from on-campus" do
      before do
        document.visibility = 'on-campus'
      end

      it "changes to authenticated" do
        document.visibility = 'authenticated'
        expect(document.read_groups).to eq ['registered']
      end

      it "changes to restricted" do
        document.visibility = 'restricted'
        expect(document.read_groups).to eq []
      end

      it "changes to open" do
        document.visibility = 'open'
        expect(document.read_groups).to eq ['public']
      end
    end
  end
end
