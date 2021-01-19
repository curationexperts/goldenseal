require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  let(:ability) { Ability.new(user) }
  subject { ability }
  let(:admin_set) { create(:admin_set) }

  context 'for a user who is not logged in' do
    let(:user) { User.new }

    it 'has general ability' do
      expect(subject).to be_able_to(:read, :resque)
    end
  end

  context 'for a regular logged-in user' do
    let(:user) { User.create(username: 'ability-test') }

    it 'has custom ability' do
      expect(subject).to be_able_to(:read, :resque)
      expect(subject).to be_able_to(:read, admin_set)
    end
  end

  context 'for an admin user' do
    let(:user) { User.create(username: 'admin-ability-test', group_list: ["admin"]) }
    
    it "has all abilities" do
      expect(subject).to be_able_to(:read, :resque)
      expect(subject).to be_able_to(:create, AdminSet)
      expect(subject).to be_able_to(:create, Image)
      expect(subject).to be_able_to(:create, Collection)
      expect(subject).to be_able_to(:read, admin_set)
      expect(subject).to be_able_to(:update, admin_set)
      expect(subject).to be_able_to(:allow_downloads, admin_set)
      expect(subject).to be_able_to(:prevent_downloads, admin_set)
      expect(subject).to be_able_to(:destroy, admin_set)
      expect(subject).to be_able_to(:confirm_delete, admin_set)
      expect(subject).to be_able_to(:collect, Image.new)
    end
  end
end
