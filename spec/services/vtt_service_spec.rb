require 'rails_helper'

describe VTTService do
  let(:tei) { File.read('spec/fixtures/tei/add14885.01250.032.xml') }
  subject { described_class.create(tei) }

  it { is_expected.to start_with "WEBVTT\n" \
       "kind: captions\n" \
       "lang: en\n" \
       "\n" \
       "\n" \
       "00:00:33.000 --> 00:06:01.000\n" \
       "<v INTERVIEWER:>All right Mr. Addonizio." }
end
