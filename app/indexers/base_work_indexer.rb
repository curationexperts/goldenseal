class BaseWorkIndexer < CurationConcerns::GenericWorkIndexingService

  def generate_solr_document
    super do |solr_doc|
      solr_doc['rights_label_ss'] = CurationConcerns.config.cc_licenses.key(object.rights.first)
    end
  end

end
