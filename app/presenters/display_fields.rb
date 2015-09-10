module DisplayFields
  extend ActiveSupport::Concern

  # Common fields for presenters to display

  def identifier
    solr_document['identifier_tesim']
  end

end
