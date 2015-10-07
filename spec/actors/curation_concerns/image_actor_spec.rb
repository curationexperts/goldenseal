require 'rails_helper'

describe CurationConcerns::ImageActor do
  let(:actor) { described_class.new(curation_concern, user, attrs) }
  let(:curation_concern) { Image.new }
  let(:user) { User.new }

  describe '#transform_dates' do
    subject { actor.attributes['date_issued'] }
    let(:datetime) { DateTime.parse('2015-11-03').utc }

    before { actor.transform_dates }

    context 'with a string for the key' do
      let(:attrs) { { 'date_issued' => '2015-11-03' } }
      it { is_expected.to eq datetime }
    end

    context 'with a symbol for the key' do
      let(:attrs) { { date_issued: '2015-11-03' } }
      it { is_expected.to eq datetime }
    end
  end
end
