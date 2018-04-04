class FileSetPresenter < CurationConcerns::FileSetPresenter
  def permission_badge_class
    ::PermissionBadge
  end

  delegate :prevent_download, to: :solr_document
end
