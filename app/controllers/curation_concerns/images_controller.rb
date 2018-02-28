class CurationConcerns::ImagesController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type Image

  def show_presenter
    ::ImagePresenter
  end

  delegate :downloadable, to: :solr_document
end
