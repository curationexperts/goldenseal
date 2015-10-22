class FileSetPresenter < CurationConcerns::FileSetPresenter
  def permission_badge_class
    ::PermissionBadge
  end
end
