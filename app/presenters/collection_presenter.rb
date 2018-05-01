class CollectionPresenter < CurationConcerns::CollectionPresenter
  include ExhibitPresenter 

  def spotlight_exhibit
    @spotlight_exhibit ||= Spotlight::Exhibit
      .where(exhibitable_id: @solr_document['id'])
      .where(exhibitable_type: 'Collection')
      .first
  end
end
