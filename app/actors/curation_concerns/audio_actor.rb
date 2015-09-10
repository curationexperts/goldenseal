# Generated via
#  `rails generate curation_concerns:work Audio`
module CurationConcerns
  class AudioActor < CurationConcerns::BaseActor
    include ::CurationConcerns::WorkActorBehavior
    include CommonActorBehavior
  end
end
