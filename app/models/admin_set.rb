class AdminSet < ActiveFedora::Base
  include Hydra::AccessControls::Permissions
  include CurationConcerns::HumanReadableType
  include CurationConcerns::HasRepresentative

  self.human_readable_type = 'Administrative Collection'

  has_many :members,
    predicate: ::RDF::Vocab::DC.isPartOf,
    class_name: "ActiveFedora::Base"

  validates :title, presence: { message: 'Your collection must have a title.' }
  validates :identifier, presence: { message: 'Your collection must have an identifier.' }
  validates_format_of :identifier, with: /\A(\w|-|.)+\z/

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
  after_create :create_spotlight_exhibit
  before_save :update_spotlight_exhibit

  def assign_access
    self.read_groups += ['public']
  end

  def self.indexer
    AdminSetIndexer
  end

  def spotlight_exhibit
    @spotlight_exhibit ||= Spotlight::Exhibit.where(admin_set_id: self.id).first
  end

  private
  def create_spotlight_exhibit
    Spotlight::Exhibit.where(admin_set_id: self.id).first_or_create do |exhibit|
      exhibit.title = self.title
      exhibit.published = true
    end
  end

  def update_spotlight_exhibit
    if self.valid? && self.title_changed? && spotlight_exhibit
      spotlight_exhibit.update_attributes({
        title: self.title
      })
    end
  end
end
