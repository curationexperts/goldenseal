class AdminSetIndexer < ActiveFedora::IndexingService
  include CurationConcerns::IndexesThumbnails
  def generate_solr_document
    super.tap do |solr_doc|
      # Makes these show under the "Collections" tab
      Solrizer.set_field(solr_doc, 'generic_type', 'Collection', :facetable)
      solr_doc['thumbnail_path_ss'] = thumbnail_path
    end
  end
end
