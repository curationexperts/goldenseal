class ImageInfo
  include Blacklight::SearchHelper

  def initialize(id)
    @id = id
  end

  def dimensions
    doc = fetch(@id).first['response']['docs'].first
    { height: doc['height_is'], width: doc['width_is'] }
  end

  def search_builder_class
    CurationConcerns::SearchBuilder
  end

  def blacklight_config
    CatalogController.blacklight_config
  end
end

