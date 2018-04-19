class BaseWorkIndexer < CurationConcerns::WorkIndexer
  def generate_solr_document
    super do |solr_doc|
      solr_doc['rights_label_ss'] = rights_labels.first
      solr_doc['admin_set_ssi'] = object.admin_set.try(:title)
      solr_doc['custom_metadata_fields_ssm'] = object.custom_metadatas.collect{|datapoint| datapoint.title.parameterize.underscore }
      object.custom_metadatas.each do |datapoint|
        next if datapoint.title.blank?
        solr_doc["#{datapoint.title.parameterize.underscore}_ssi"] = datapoint.value
      end
      yield(solr_doc) if block_given?
    end
  end

  private

    def rights_labels
      object.rights.map { |r| RightsService.label(r) }
    end
end
