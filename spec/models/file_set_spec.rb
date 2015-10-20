require 'rails_helper'

describe FileSet do
  describe 'on_campus_only_access?' do
    subject { described_class.new.on_campus_only_access? }
    it { is_expected.to be false }
  end
end
