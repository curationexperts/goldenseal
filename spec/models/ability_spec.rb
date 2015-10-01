require 'rails_helper'
require 'cancan/matchers'

describe Ability do
  let(:ability) { Ability.new(user) }
  subject { ability }

  context 'for a user who is not logged in' do
    let(:user) { User.new }

    it {
      is_expected.to_not be_able_to(:read, :resque)
    }
  end

  context 'for a regular logged-in user' do
    let(:user) { create(:user) }

    it {
      is_expected.to_not be_able_to(:read, :resque)
    }
  end

  context 'for an admin user' do
    let(:user) { create(:user, group_list: ['admin']) }

    it {
      is_expected.to be_able_to(:read, :resque)
    }
  end
end
