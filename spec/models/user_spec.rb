require 'rails_helper'

describe User do

  describe '#groups' do

    context 'for a new user (not persisted)' do
      let(:user) { described_class.new }
      subject { user.groups }

      it "doesn't look for a cache" do
        allow_any_instance_of(User).to receive(:cached_groups).and_raise("Shouldn't call 'cached_groups' method")
        expect(subject).to eq []
      end
    end

  end

end
