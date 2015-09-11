module Metadata
  extend ActiveSupport::Concern

  included do
    property :date_issued, predicate: ::RDF::DC.issued, multiple: false do |index|
      index.type :date
      index.as :stored_sortable
    end

    property :note, predicate: ::RDF::Vocab::MODS.note do |index|
      index.as :stored_searchable
    end

    property :publication_place, predicate: ::RDF::Vocab::MARCRelators.pup do |index|
      index.as :stored_searchable
    end
  end

end
