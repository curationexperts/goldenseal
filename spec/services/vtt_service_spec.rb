require 'rails_helper'

describe VTTService do
  let(:tei) { File.read('spec/fixtures/tei/add14885.01250.032.xml') }
  subject { described_class.create(tei) }

  it { is_expected.to start_with "WEBVTT\nkind: captions\nlang: en\n\n[camera roll 403:24][sound roll 403:12][slate marker visible on screen]<v INTERVIEWER:> All right Mr. Addonizio." }
end
