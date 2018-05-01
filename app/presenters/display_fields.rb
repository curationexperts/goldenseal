module DisplayFields
  extend ActiveSupport::Concern

  included do
    delegate :identifier, 
      :custom_metadata_fields,
      :date_issued, 
      :description_standard,
      :editor, 
      :extent,
      :filename,
      :funder,
      :height, 
      :mime_type, 
      :note, 
      :publication_place, 
      :representative_id,
      :researcher, 
      :series,
      :source,
      :sponsor,
      :thumbnail_id,
      :width, 
      to: :solr_document
  end

  def permission_badge_class
    ::PermissionBadge
  end

  # Overridden to create the correct presenters.
  def file_presenter_class
    ::FileSetPresenter
  end
end
