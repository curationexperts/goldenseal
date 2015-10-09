require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  let(:ability) { Ability.new(user) }
  subject { ability }
  let(:admin_set) { create(:admin_set) }

  context 'for a user who is not logged in' do
    let(:user) { User.new }

    it {
      is_expected.to_not be_able_to(:read, :resque)
    }
  end

  context 'for a regular logged-in user' do
    let(:user) { create(:user) }

    it {
      is_expected.not_to be_able_to(:read, :resque)
      is_expected.not_to be_able_to(:create, AdminSet)
      is_expected.to be_able_to(:read, admin_set)
      is_expected.not_to be_able_to(:update, admin_set)
      is_expected.not_to be_able_to(:destroy, admin_set)
      is_expected.not_to be_able_to(:confirm_delete, admin_set)
    }
  end

  context 'for an admin user' do
    let(:user) { create(:user, group_list: ['admin']) }

    it {
      is_expected.to be_able_to(:read, :resque)
      is_expected.to be_able_to(:create, AdminSet)
      is_expected.to be_able_to(:read, admin_set)
      is_expected.to be_able_to(:update, admin_set)
      is_expected.to be_able_to(:destroy, admin_set)
      is_expected.to be_able_to(:confirm_delete, admin_set)
    }
  end
end
