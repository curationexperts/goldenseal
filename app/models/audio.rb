class Audio < ActiveFedora::Base
  include CurationConcerns::WorkBehavior
  include CurationConcerns::BasicMetadata
  include Metadata
  include InAdminSet

  validates :title, presence: { message: 'Your work must have a title.' }

  include WithTEI

  def self.indexer
    BaseWorkIndexer
  end
end
