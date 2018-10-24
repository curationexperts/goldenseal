class BaseWorkIndexer < CurationConcerns::WorkIndexer
  TEI_JSON = 'tei_json_tesi'
  include Rails.application.routes.url_helpers

  def generate_solr_document
    relative_thumb_path = CurationConcerns::ThumbnailPathService.call(object)
    super do |solr_doc|
      solr_doc[TEI_JSON] = ActionView::Base.full_sanitizer.sanitize(tei) if tei
      solr_doc['oai_identifier_ssm'] = [
        url_for(object),
        "http://#{Rails.application.routes.default_url_options[:host]}#{relative_thumb_path}",
        object.identifier
      ]
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

    def tei_to_json
      as_json = tei_as_json
      return unless as_json
      JSON.generate(as_json)
    end

    def tei
      @tei ||= object.try(:tei).try(:original_file).try(:content)
    end
    
    def tei_as_json
      # OPTIMIZE: this could be indexed on the FileSet which
      # so that every index call wouldn't have to load the tei file.
      return unless tei
      TEIConverter.new(tei, object).as_json
    end
end
