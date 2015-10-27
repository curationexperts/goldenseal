module DisplayFields
  extend ActiveSupport::Concern

  included do
    delegate :identifier, :series, :date_issued, :note, :extent,
             :description_standard, :publication_place, :editor, :sponsor,
             :funder, :researcher, :height, :width, :mime_type, :filename,
             :representative_id, :thumbnail_id, to: :solr_document
  end

  def permission_badge_class
    ::PermissionBadge
  end

  # Overridden to create the correct presenters.
  def file_presenter_class
    ::FileSetPresenter
  end
end
