require 'rails_helper'

describe VTTService do
  let(:tei) { File.read('spec/fixtures/tei/add14885.01250.032.xml') }
  subject { described_class.create(tei) }

  it { is_expected.to eq "<div class=\"transcript\"></div>\n" }
end
