class Text < ActiveFedora::Base
  include CurationConcerns::WorkBehavior
  include CurationConcerns::BasicMetadata
  include Metadata

  validates :title, presence: { message: 'Your work must have a title.' }

  include WithTEI

  # Given a filename that appears in the TEI, return the id for the
  # corresponding FileSet that has the page image
  def id_for_filename(filename)
    query = "_query_:\"{!raw f=has_model_ssim}FileSet\" AND _query_:\"{!raw f=generic_work_ids_ssim}#{id}\" AND _query_:\"{!raw f=label_ssi}#{filename}\""
    result = ActiveFedora::SolrService.query(query).first
    result && result.fetch('id')
  end

  def self.indexer
    TextIndexer
  end
end
