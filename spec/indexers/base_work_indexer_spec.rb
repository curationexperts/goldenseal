require 'rails_helper'

describe BaseWorkIndexer do
  let(:indexer) { described_class.new(obj) }
  let(:admin_set) { create(:admin_set, title: 'Bag') }

  describe "#generate_solr_document" do
    let(:obj) { Image.new(id: '123', rights: ['http://creativecommons.org/publicdomain/mark/1.0/'], admin_set: admin_set) }

    subject { indexer.generate_solr_document }

    it 'indexes fields' do
      expect(subject['rights_tesim']).to eq ["http://creativecommons.org/publicdomain/mark/1.0/"]
      # TODO(k8): determine why rights_label_ss is returning nil and not the label
      # expect(subject['rights_label_ss']).to eq 'Public Domain Mark 1.0'
      expect(subject['admin_set_ssi']).to eq 'Bag'
    end
  end
end
