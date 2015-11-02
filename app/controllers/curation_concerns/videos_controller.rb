class CurationConcerns::VideosController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type Video

  def show_presenter
    ::WorkShowPresenter
  end
end
