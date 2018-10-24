class CollectionsController < ApplicationController
  include CurationConcerns::CollectionsControllerBehavior
  include CurationConcerns::CollectionsControllerBehaviorEnhancements

  def presenter_class
    CollectionPresenter
  end
end
