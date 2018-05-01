require 'rails_helper'

describe Video do
  let(:exhibit){ Spotlight::Exhibit.create(title: 'Exhibit', slug: 'my-exhibit') }
  let(:user){ User.create username: 'testuser'}
  let(:document) do
    instance = described_class.create(exhibit_id: exhibit.id, title: ['my Video'])
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

    it "should persist exhibit_id" do
      expect(document.exhibit_id).to eq 1
    end

    it "should reindex" do
      document.reindex
    end
  end
end
