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

  # TODO: Update the solr field when we go to CurationConcerns 0.2.0
  # TODO: this method can be removed when we upgrade to CurationConcerns 0.3.0 (not released)
  def file_presenters
    @file_sets ||= begin
      ids = solr_document.fetch('member_ids_ssim', [])
      CurationConcerns::PresenterFactory.build_presenters(ids, file_presenter_class, current_ability)
    end
  end

  # Overridden to create the correct presenters.
  def file_presenter_class
    ::FileSetPresenter
  end
end
