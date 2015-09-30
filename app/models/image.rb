# Generated via
#  `rails generate curation_concerns:work Image`
class Image < ActiveFedora::Base
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Metadata

  validates :title, presence: { message: 'Your work must have a title.' }

  def self.indexer
    ImageIndexer
  end
end
