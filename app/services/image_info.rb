class ImageInfo
  include Blacklight::SearchHelper

  def initialize(id)
    @id = id
  end

  def dimensions
    doc = fetch(@id).first['response']['docs'].first
    { height: doc['height_isi'], width: doc['width_isi'] }
  end

  def search_builder_class
    CurationConcerns::SearchBuilder
  end

  def blacklight_config
    CatalogController.blacklight_config
  end
end

