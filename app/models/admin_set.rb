class AdminSet < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include CurationConcerns::HumanReadableType
  include CurationConcerns::HasRepresentative

  self.human_readable_type = 'Administrative Collection'

  has_many :members,
    predicate: ::RDF::DC.isPartOf,
    class_name: "ActiveFedora::Base"

  validates :title, presence: { message: 'Your collection must have a title.' }
  validates :identifier, presence: { message: 'Your collection must have an identifier.' }

  property :title, predicate: ::RDF::DC.title, multiple: false do |index|
    index.as :stored_searchable
  end

  property :identifier, predicate: ::RDF::DC.identifier, multiple: false do |index|
    index.as :stored_sortable
  end

  property :description, predicate: ::RDF::DC.description, multiple: false do |index|
    index.as :stored_searchable
  end

  property :contributor, predicate: ::RDF::DC.contributor do |index|
    index.as :stored_searchable
  end

  property :creator, predicate: ::RDF::DC.creator do |index|
    index.as :stored_searchable
  end

  property :subject, predicate: ::RDF::DC.subject do |index|
    index.as :stored_searchable
  end

  property :publisher, predicate: ::RDF::DC.publisher do |index|
    index.as :stored_searchable
  end

  property :language, predicate: ::RDF::DC.language do |index|
    index.as :stored_searchable
  end

  before_create :assign_access

  def assign_access
    self.read_groups += ['public']
  end

  def self.indexer
    AdminSetIndexer
  end
end
