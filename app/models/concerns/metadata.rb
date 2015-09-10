module Metadata
  extend ActiveSupport::Concern

  included do
    property :date_issued, predicate: ::RDF::DC.issued, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end
  end

end
