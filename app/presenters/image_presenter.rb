class ImagePresenter < WorkShowPresenter
  include DisplayFields

  delegate :prevent_download, to: :solr_document
end
