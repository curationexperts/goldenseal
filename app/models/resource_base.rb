class ResourceBase < ActiveFedora::Base
  include CurationConcerns::WorkBehavior
  include CurationConcerns::BasicMetadata
  include Metadata
  include InAdminSet
  include OnCampusAccess
  include DrawTemplate

  #Spotlight
  #include Spotlight::SolrDocument::AtomicUpdates
  #include ActiveSupport::Benchmarkable

  # these break indexing for CurationConcern based works
  #include Spotlight::Resources::GeneratingSolrDocuments 
  #include Spotlight::Resources::Indexing

  class_attribute :weight

  #serialize :data, Hash
  # store :metadata, accessors: [
    # :last_indexed_estimate,
    # :last_indexed_count,
    # :last_index_elapsed_time,
    # :last_indexed_finished], coder: JSON

  #enum index_status: [:waiting, :completed, :errored]

  ##
  # Persist the record, and trigger a reindex to solr
  #
  # @param [Hash] All arguments will be passed through to ActiveFedora's #save method
  def save_and_index(*args)
    save(*args) && reindex
  end

  # Spotlight attributes
  # exhibit_id
  # type
  # url
  # data
  # indexed_at
  # created_at
  # updated_at
  # metadata
  # index_status
  
  # Spotlight methods
  # reindex_later
  # save_and_index
  # concerning :GeneratingSolrDocuments
  #   to_solr 
  #     - exists
  #   documents_to_index
  #   existing_solr_doc_hash
  #   unique_key
  #   exhibit_specific_solr_data
  #   spotlight_resource_metadata_for_solr
  #   document_modal
  # concerning :Indexing
  #   reindex
  #   reindex_with_logging
  #   blacklight_solr
  #   connection_config
  #   batch_size
  #   write_to_index
  #   commit

  property :exhibit_name, predicate: ::RDF::Vocab::DC.abstract, multiple: true do |index|
    index.as :stored_searchable
  end

  property :indexed_at, predicate: ::RDF::Vocab::DC.abstract, multiple: false

  #Need to be part of metadata
  property :last_indexed_estimate, predicate: ::RDF::Vocab::DC.abstract, multiple: false
  property :last_indexed_count, predicate: ::RDF::Vocab::DC.abstract, multiple: false
  property :last_index_elapsed_time, predicate: ::RDF::Vocab::DC.abstract, multiple: false
  property :last_indexed_finished, predicate: ::RDF::Vocab::DC.abstract, multiple: false

  # property :data, predicate: ::RDF::DC.description, multiple: false do |index|
    # index.as :stored
  # end

  alias_method :index, :update_index
  alias_method :to_global_id, :id

  def exhibit
    if self.exhibit_name
      Spotlight::Exhibit.where(title: self.exhibit_name).first
    end
  end
end
