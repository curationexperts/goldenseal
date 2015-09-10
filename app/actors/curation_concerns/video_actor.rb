# Generated via
#  `rails generate curation_concerns:work Video`
module CurationConcerns
  class VideoActor < CurationConcerns::BaseActor
    include ::CurationConcerns::WorkActorBehavior
    include CommonActorBehavior
  end
end
