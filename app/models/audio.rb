class Audio < ActiveFedora::Base
  include CurationConcerns::WorkBehavior
  include CurationConcerns::BasicMetadata
  include Metadata
  include InAdminSet
  include OnCampusAccess
  include DrawTemplate

  validates :title, presence: { message: 'Your work must have a title.' }

  include WithTEI

  def self.indexer
    BaseWorkIndexer
  end

  property :prevent_download, predicate: ::RDF::Vocab::DC.Policy, multiple: false do |index|
    index.as :stored_searchable
  end

  def prevent_download= value
    super value.to_s.downcase == "true" 
  end
end
