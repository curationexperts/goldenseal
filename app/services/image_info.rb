class ImageInfo
  include Blacklight::SearchHelper

  def initialize(id)
    @id = id
  end

  def dimensions
    { height: solr_document['height_is'], width: solr_document['width_is'] }
  end

  def solr_document
    @solr_document ||= fetch_solr_document
  end

  private

    def fetch_solr_document
      doc = fetch(@id).first['response']['docs'].first
      # TODO mime_type field is changing: https://github.com/curationexperts/goldenseal/issues/138
      doc.slice('height_is', 'width_is', 'mime_type_tesim', 'label_ssi')
    end

    def search_builder_class
      CurationConcerns::SearchBuilder
    end

    def blacklight_config
      CatalogController.blacklight_config
    end
end

