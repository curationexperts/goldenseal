require 'rails_helper'

describe BaseWorkIndexer do
  let(:indexer) { described_class.new(obj) }

  describe "#generate_solr_document" do
    let(:obj) { Image.new(id: '123', rights: ['http://creativecommons.org/publicdomain/mark/1.0/']) }

    subject { indexer.generate_solr_document }

    it 'indexes a display label for the rights' do
      expect(subject['rights_label_ss']).to eq 'Public Domain Mark 1.0'
    end
  end
end
