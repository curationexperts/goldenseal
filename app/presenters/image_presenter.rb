class ImagePresenter < WorkShowPresenter
  include DisplayFields

  delegate :downloadable, to: :solr_document
end
