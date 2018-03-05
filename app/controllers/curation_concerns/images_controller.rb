class CurationConcerns::ImagesController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type Image

  def show_presenter
    ::ImagePresenter
  end

  delegate :prevent_download, to: :solr_document
end
