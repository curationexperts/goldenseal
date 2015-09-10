require 'rails_helper'

describe CurationConcerns::ImageActor do
  let(:actor) { described_class.new(curation_concern, user, attrs) }
  let(:curation_concern) { Image.new }
  let(:user) { User.new }

  describe '#transform_dates' do
    subject { actor.attributes['date_issued'] }

    before { actor.transform_dates }

    context 'with a String value for the date' do
      let(:attrs) {{ 'date_issued' => '2015-11-03' }}

      it 'casts the String to a DateTime' do
        expect(subject).to eq DateTime.parse('2015-11-03')
      end
    end

    context 'with a blank String for the date' do
      let(:attrs) {{ 'date_issued' => '' }}

      it 'returns without transforming the value' do
        expect(subject).to eq ''
      end
    end

    context 'with a DateTime value for the date' do
      let(:attrs) {{ 'date_issued' => DateTime.parse('2015-11-03') }}

      it 'returns without transforming the value' do
        expect(subject).to eq DateTime.parse('2015-11-03')
      end
    end

    context 'with a symbol for the key' do
      let(:attrs) {{ date_issued: '2015-11-03' }}

      it 'casts the String to a DateTime' do
        expect(subject).to eq DateTime.parse('2015-11-03')
      end
    end

  end

end
