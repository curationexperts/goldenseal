require 'rails_helper'

describe FileSetPresenter do
  let(:solr_doc) { nil }
  let(:ability) { nil }
  let(:presenter) { described_class.new(solr_doc, ability) }

  describe "#permission_badge_class" do
    subject { presenter.permission_badge_class }
    it { is_expected.to eq PermissionBadge }
  end
end
