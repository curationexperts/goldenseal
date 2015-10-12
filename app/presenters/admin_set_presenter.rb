class AdminSetPresenter
  include CurationConcerns::ModelProxy
  include CurationConcerns::PresentsAttributes
  attr_reader :solr_document

  # Metadata Methods
  delegate :title, :description, :creator, :contributor, :subject, :publisher, :language,
           :embargo_release_date, :lease_expiration_date, :rights, :human_readable_type,
           to: :solr_document

  # @param [SolrDocument] solr_document
  def initialize(solr_document)
    @solr_document = solr_document
  end
end
