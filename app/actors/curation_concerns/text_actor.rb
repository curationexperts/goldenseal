# Generated via
#  `rails generate curation_concerns:work Text`
module CurationConcerns
  class TextActor < CurationConcerns::BaseActor
    include ::CurationConcerns::WorkActorBehavior
    include CommonActorBehavior
  end
end
