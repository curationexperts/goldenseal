require 'rails_helper'

describe AdminSetIndexer do
  let(:indexer) { described_class.new(admin_set) }
  let(:admin_set) { build(:admin_set) }

  describe "#generate_solr_document" do
    subject { indexer.generate_solr_document }

    it "has fields" do
      expect(subject.fetch('generic_type_sim')).to eq ["Collection"]
      expect(subject.fetch('title_tesim')).to eq ["test admin set"]
      expect(subject.fetch('identifier_ssi')).to eq 'admin001'
      expect(subject.fetch('description_tesim')).to eq ["Portraits taken by Anne Leibovitz"]
      expect(subject.fetch('creator_tesim')).to eq ["Leibovitz, Anna-Lou \"Anne\""]
      expect(subject.fetch('contributor_tesim')).to eq ["Loengard, John"]
      expect(subject.fetch('subject_tesim')).to eq ["People"]
      expect(subject.fetch('publisher_tesim')).to eq ["Rolling Stone Magazine"]
      expect(subject.fetch('language_tesim')).to eq ["English"]
      expect(subject.fetch('thumbnail_path_ss')).to eq "/assets/default.png"
    end
  end
end
