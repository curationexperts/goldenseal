# Generated via
#  `rails generate curation_concerns:work Document`
module CurationConcerns
  class DocumentActor < CurationConcerns::BaseActor
    include ::CurationConcerns::WorkActorBehavior
    include CommonActorBehavior
  end
end
