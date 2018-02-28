class FileSetPresenter < CurationConcerns::FileSetPresenter
  def permission_badge_class
    ::PermissionBadge
  end

  delegate :downloadable, to: :solr_document
end
