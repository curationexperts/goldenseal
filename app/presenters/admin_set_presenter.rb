class AdminSetPresenter
  include CurationConcerns::ModelProxy
  include CurationConcerns::PresentsAttributes
  attr_reader :solr_document

  # Metadata Methods
  delegate :title, :description, :creator, :contributor, :subject, :publisher, :language,
           :embargo_release_date, :lease_expiration_date, :rights, :human_readable_type,
           :representative_id,
           to: :solr_document

  # @param [SolrDocument] solr_document
  def initialize(solr_document)
    @solr_document = solr_document
  end

  def attribute_to_html(field, options={})
    case field
    when :spotlight_exhibit
      SpotlightExhibitRenderer.new(:spotlight, [spotlight_exhibit_title], link_path: edit_exhibit_path).render if spotlight_exhibit
    else
      super
    end
  end

  def spotlight_exhibit
    @spotlight_exhibit ||= Spotlight::Exhibit.where(admin_set_id: @solr_document['id']).first
  end

  def edit_exhibit_path
    Spotlight::Engine.routes.url_helpers.edit_exhibit_path(spotlight_exhibit) if spotlight_exhibit 
  end

  def spotlight_exhibit_title
    spotlight_exhibit.title if spotlight_exhibit
  end
end
