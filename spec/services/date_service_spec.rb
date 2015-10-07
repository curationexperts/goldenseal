require 'rails_helper'

describe DateService do

  describe '.parse' do
    subject { DateService.parse(input_date) }

    context 'with an iso-formatted date' do
      let(:input_date) { '2015-11-03' }

      it 'casts the String to a DateTime' do
        expect(subject).to eq DateTime.parse('2015-11-03').utc
      end
    end

    context 'with a slash delimited date' do
      let(:input_date) { '2015/11/03' }

      it 'casts the String to a DateTime' do
        expect(subject).to eq DateTime.parse('2015-11-03').utc
      end
    end

    context 'with a blank value' do
      let(:input_date) { '' }
      it { is_expected.to be_nil }
    end

    context 'when it is already a DateTime' do
      let(:input_date) { DateTime.parse('2015-11-03').utc }

      it 'returns the input value' do
        expect(subject).to eq input_date
      end
    end

    context 'when it is already a Date' do
      let(:input_date) { Date.today }

      it 'returns the input value' do
        expect(subject).to eq input_date
      end
    end

    context 'a year-only date' do
      let(:input_date) { '2004' }

      it 'returns the input value' do
        expect(subject).to eq input_date
      end
    end

    context 'a year-only date with extra whitespace' do
      let(:input_date) { '  2004   ' }

      it 'returns the input value with whitespace stripped' do
        expect(subject).to eq '2004'
      end
    end

    context 'when the date is unparseable' do
      let(:input_date) { 'something unparseable' }

      it 'returns the input value' do
        expect(subject).to eq input_date
      end
    end
  end

end
