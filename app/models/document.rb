# Generated via
#  `rails generate curation_concerns:work Document`
class Document < ActiveFedora::Base
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  include Metadata

  validates_presence_of :title,  message: 'Your work must have a title.'

  def self.indexer
    BaseWorkIndexer
  end
end
