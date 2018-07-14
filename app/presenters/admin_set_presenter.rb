class AdminSetPresenter
  include CurationConcerns::ModelProxy
  include CurationConcerns::PresentsAttributes
  include ExhibitPresenter 
  attr_reader :solr_document

  # Metadata Methods
  delegate :contributor,
    :creator,
    :description,
    :embargo_release_date,
    :human_readable_type,
    :language,
    :lease_expiration_date,
    :publisher,
    :representative_id,
    :rights,
    :subject,
    :title,
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
    @spotlight_exhibit ||= Spotlight::Exhibit
      .where(exhibitable_id: @solr_document['id'])
      .where(exhibitable_type: 'AdminSet')
      .first
  end

end
