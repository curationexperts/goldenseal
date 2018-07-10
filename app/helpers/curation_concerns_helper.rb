module CurationConcernsHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers

  # Override for AdminSets
  def url_for_document(doc, _options = {})
    case doc.fetch('has_model_ssim').first
    when AdminSet.to_class_uri
       exhibit = Spotlight::Exhibit
         .where(exhibitable_id: doc.id)
         .where(exhibitable_type: 'AdminSet')
         .first
       if exhibit
         spotlight.exhibit_root_path exhibit
       else
         admin_set_path doc.id
       end
    when Collection.to_class_uri
       exhibit = Spotlight::Exhibit
         .where(exhibitable_id: doc.id)
         .where(exhibitable_type: 'Collection')
         .first
       if exhibit
         spotlight.exhibit_root_path exhibit
       else
         super
       end
    else
      super
    end
  end

  def track_admin_set_path(*args)
    track_solr_document_path(*args)
  end

  def allow_download_link(presenter, query)
    if presenter.kind_of? CurationConcerns::CollectionPresenter
      allow_downloads_path(presenter, query)
    elsif presenter.kind_of? AdminSetPresenter 
      admin_set_allow_downloads_path(presenter, query)
    end
  end

  def prevent_download_link(presenter, query)
    if presenter.kind_of? CurationConcerns::CollectionPresenter
      prevent_downloads_path(presenter, query)
    elsif presenter.kind_of? AdminSetPresenter
      admin_set_prevent_downloads_path(presenter, query) 
    end
  end
end
