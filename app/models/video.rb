# Generated via
#  `rails generate curation_concerns:work Video`
class Video < ActiveFedora::Base
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Metadata

  validates :title, presence: { message: 'Your work must have a title.' }

  include WithTEI

  def self.indexer
    BaseWorkIndexer
  end
end
