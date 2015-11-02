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
      is_expected.not_to be_able_to(:create, Image)
      is_expected.not_to be_able_to(:create, Collection)
      is_expected.to be_able_to(:read, admin_set)
      is_expected.not_to be_able_to(:update, admin_set)
      is_expected.not_to be_able_to(:destroy, admin_set)
      is_expected.not_to be_able_to(:confirm_delete, admin_set)
      # Since we can't create collections, it doesn't make sense to allow them
      # to collect items. This keeps the widget from being displayed.
      is_expected.not_to be_able_to(:collect, Image.new)
    }
  end

  context 'for an admin user' do
    let(:user) { create(:user, group_list: ['admin']) }

    it {
      is_expected.to be_able_to(:read, :resque)
      is_expected.to be_able_to(:create, AdminSet)
      is_expected.to be_able_to(:create, Image)
      is_expected.to be_able_to(:create, Collection)
      is_expected.to be_able_to(:read, admin_set)
      is_expected.to be_able_to(:update, admin_set)
      is_expected.to be_able_to(:destroy, admin_set)
      is_expected.to be_able_to(:confirm_delete, admin_set)
      is_expected.to be_able_to(:collect, Image.new)
    }
  end
end
