class BaseWorkIndexer < CurationConcerns::WorkIndexer
  include Rails.application.routes.url_helpers

  def generate_solr_document
    relative_thumb_path = CurationConcerns::ThumbnailPathService.call(object)
    super do |solr_doc|
      solr_doc['oai_identifier_ssm'] = [
        url_for(object),
        "http://#{Rails.application.routes.default_url_options[:host]}#{relative_thumb_path}",
        object.identifier
      ]
      solr_doc['rights_label_ss'] = rights_labels.first
      solr_doc['admin_set_ssi'] = object.admin_set.try(:title)
      yield(solr_doc) if block_given?
    end
  end

  private

    def rights_labels
      object.rights.map { |r| RightsService.label(r) }
    end
end
