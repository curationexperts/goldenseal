require 'rails_helper'

describe Video do
    let(:exhibit){ Spotlight::Exhibit.create(title: 'Exhibit', slug: 'my-exhibit') }
    let(:user){ User.create username: 'testuser'}
    let(:document) do
      instance = described_class.create(title: ['my Video'])
      instance.apply_depositor_metadata(user)
      instance
    end

  describe "tei" do
    subject { document.tei }
    it { is_expected.to be_nil }
  end

  describe "basic behavior" do
    it "should save" do
      expect(document.save).to eq true
    end

    it "should persist title" do
      expect(document.title).to eq(['my Video'])
    end
  end
end
