# Generated via
#  `rails generate curation_concerns:work Text`

class CurationConcerns::TextsController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type Text

  # Gives the class of the show presenter. Override this if you want
  # to use a different presenter.
  def show_presenter
    TextPresenter
  end
end
