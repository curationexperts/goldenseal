# Generated via
#  `rails generate curation_concerns:work Audio`

class CurationConcerns::AudiosController < ApplicationController
  include CurationConcerns::CurationConcernController

  include AttachFiles
  before_filter :add_attachments_to_files, only: :create

  set_curation_concern_type Audio

  def show_presenter
    ::AudioPresenter
  end

end
