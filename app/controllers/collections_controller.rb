class CollectionsController < ApplicationController
  include CurationConcerns::CollectionsControllerBehavior

  def presenter_class
    CollectionPresenter
  end
end
