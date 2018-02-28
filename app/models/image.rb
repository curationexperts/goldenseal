class Image < ActiveFedora::Base
  include ::CurationConcerns::WorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Metadata
  include InAdminSet
  include OnCampusAccess
  include DrawTemplate

  validates :title, presence: { message: 'Your work must have a title.' }

  def self.indexer
    ImageIndexer
  end

  property :downloadable, predicate: ::RDF::Vocab::DC.Policy, multiple: false do |index|
    index.as :stored_searchable
  end

  def downloadable= value
    super value.to_s.downcase == "true" 
  end
end
