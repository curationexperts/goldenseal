# Generated via
#  `rails generate curation_concerns:work Text`

class CurationConcerns::TextsController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type Text
end
