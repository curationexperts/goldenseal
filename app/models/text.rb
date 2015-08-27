class Text < ActiveFedora::Base
  include ::CurationConcerns::GenericWorkBehavior
  include ::CurationConcerns::BasicMetadata
  validates_presence_of :title,  message: 'Your work must have a title.'
  belongs_to :tei, predicate: ::RDF::URI('http://opaquenamespace.org/ns/hasEncodedText'), class_name: 'GenericFile'

  before_save :assign_default_tei

  # if tei isn't set and there are generic_files, then set the first one
  def assign_default_tei
    unless tei_id || generic_file_ids.empty?
      self.tei_id = generic_file_ids.first
    end
  end


  # Given a filename that appears in the TEI, return the id for the
  # corresponding GenericFile that has the page image
  def id_for_filename(filename)
    query = "_query_:\"{!raw f=has_model_ssim}GenericFile\" AND _query_:\"{!raw f=generic_work_ids_ssim}#{id}\" AND _query_:\"{!raw f=title_sim}#{filename}\""
    result = ActiveFedora::SolrService.query(query).first
    result && result.fetch('id')
  end

  def self.indexer
    TextIndexer
  end
end
