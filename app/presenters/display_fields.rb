module DisplayFields
  extend ActiveSupport::Concern

  included do
    delegate :identifier, :series, :date_issued, :note, :extent,
             :description_standard, :publication_place, :editor, :sponsor,
             :funder, :researcher, :height, :width, :mime_type, :filename,
             to: :solr_document
  end

end
