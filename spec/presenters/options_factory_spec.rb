require 'rails_helper'

describe OptionsFactory do
  let(:fs_options) { { 'id' => "0k225b14x", "label_tesim"=>"transcript.xml", "label_ssi"=>"transcript.xml", "mime_type_ssi"=>"application/xml"} }

  let(:object) { double(member_ids: ['0k225b14x']) }
  let(:factory) { OptionsFactory.new(object) }

  before do
    ActiveFedora::SolrService.add fs_options, commit: true
    allow(CurationConcerns::ParentService).to receive(:ordered_by_ids).with(object_id).and_return(['0k225b14x'])
  end

  describe "#xml_options" do
    subject { factory.xml_options }
    it { is_expected.to eq [["transcript.xml", "0k225b14x"]] }
  end
end
