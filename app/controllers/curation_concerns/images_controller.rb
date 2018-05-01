class CurationConcerns::ImagesController < ApplicationController
  include CurationConcerns::CurationConcernController
  include CustomMetadata 

  set_curation_concern_type Image

  def show_presenter
    ::WorkShowPresenter
  end
end
