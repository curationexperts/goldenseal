module DisplayFields
  extend ActiveSupport::Concern

  # Common fields for presenters to display

  def identifier
    solr_document['identifier_tesim']
  end

  def date_issued
    solr_document['date_issued_dtsi']
  end

end
