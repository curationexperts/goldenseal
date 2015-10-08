class AdminSetIndexer < ActiveFedora::IndexingService
  def generate_solr_document
    super.tap do |solr_doc|
      # Makes these show under the "Collections" tab
      Solrizer.set_field(solr_doc, 'generic_type', 'Collection', :facetable)
    end
  end
end
