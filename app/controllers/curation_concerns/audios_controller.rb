# Generated via
#  `rails generate curation_concerns:work Audio`

class CurationConcerns::AudiosController < ApplicationController
  include CurationConcerns::CurationConcernController
  set_curation_concern_type Audio
end
