# Generated via
#  `rails generate curation_concerns:work Text`

class CurationConcerns::TextsController < ApplicationController
  include CurationConcerns::CurationConcernController

  include AttachFiles
  before_filter :add_attachments_to_files, only: :create

  set_curation_concern_type Text

  # Gives the class of the show presenter. Override this if you want
  # to use a different presenter.
  def show_presenter
    TextPresenter
  end

  delegate :prevent_download, to: :solr_document
end
