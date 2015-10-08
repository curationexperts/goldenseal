class AdminSet < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include CurationConcerns::HumanReadableType

  self.human_readable_type = 'Administrative Collection'

  has_many :members, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.hasCollectionMember, class_name: "ActiveFedora::Base"

  validates :title, presence: { message: 'Your collection must have a title.' }
  validates :identifier, presence: { message: 'Your collection must have an identifier.' }

  property :title, predicate: ::RDF::DC.title, multiple: false do |index|
    index.as :stored_searchable
  end
  property :identifier, predicate: ::RDF::DC.identifier, multiple: false
  property :description, predicate: ::RDF::DC.description, multiple: false

  property :contributor, predicate: ::RDF::DC.contributor
  property :creator, predicate: ::RDF::DC.creator
  property :subject, predicate: ::RDF::DC.subject
  property :publisher, predicate: ::RDF::DC.publisher
  property :language, predicate: ::RDF::DC.language

  before_create :assign_access

  def assign_access
    self.read_groups += ['public']
  end

  def self.indexer
    AdminSetIndexer
  end
end
