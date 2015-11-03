module Metadata
  extend ActiveSupport::Concern

  included do
    property :date_issued, predicate: ::RDF::DC.issued, multiple: false do |index|
      index.as :stored_sortable
    end

    property :extent, predicate: ::RDF::DC.extent do |index|
      index.as :symbol
    end

    property :series, predicate: ::RDF::URI('http://opaquenamespace.org/ns/seriesName') do |index|
      index.as :symbol
    end

    property :note, predicate: ::RDF::Vocab::MODS.note do |index|
      index.as :stored_searchable
    end

    property :publication_place, predicate: ::RDF::Vocab::MARCRelators.pup do |index|
      index.as :stored_searchable
    end

    property :description_standard, predicate: ::RDF::Vocab::MODS.recordDescriptionStandard do |index|
      index.as :symbol
    end

    property :editor, predicate: ::RDF::Vocab::MARCRelators.edt do |index|
      index.as :stored_searchable
    end

    property :sponsor, predicate: ::RDF::Vocab::MARCRelators.spn do |index|
      index.as :stored_searchable
    end

    property :funder, predicate: ::RDF::Vocab::MARCRelators.fnd do |index|
      index.as :stored_searchable
    end

    property :researcher, predicate: ::RDF::Vocab::MARCRelators.res do |index|
      index.as :stored_searchable
    end
  end
end
