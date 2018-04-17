module SpotlightAttributes
  extend ActiveSupport::Concern

  # TODO: this needs paperclip like behavior
  #   from spotlight: app/controllers/concerns/spotlight/base.rb
  #      thumbnails: doc.spotlight_image_versions.try(:thumb) || doc[blacklight_config.index.thumbnail_field],
  #      full_image_url: doc.spotlight_image_versions.try(:full).try(:first),
  #      full_images: doc.spotlight_image_versions.try(:full),
  #      image_versions: doc.spotlight_image_versions.image_versions(:thumb, :full),
  included do
    klass_name = self.name
    has_and_belongs_to_many :custom_metadatas, predicate: ::RDF::Vocab::DCAT.CatalogRecord, class_name: "#{klass_name}::CustomMetadata", inverse_of: klass_name.downcase.pluralize
    accepts_nested_attributes_for :custom_metadatas

    property :spotlight_image_versions, predicate: ::RDF::Vocab::DC.abstract, multiple: true do |index|
      index.as :stored_sortable
    end

    self::CustomMetadata = Class.new(ActiveFedora::Base) do
      type ::RDF::URI('http://example.org/terms/custom_metadata_set')
      has_many klass_name.downcase.pluralize.intern, inverse_of: :custom_metadatas, class_name: klass_name
      property :title, predicate: ::RDF::Vocab::DC.title, class_name: ::RDF::Literal, multiple: false
      property :value, predicate: ::RDF::Vocab::DC.description, class_name: ::RDF::Literal, multiple: false
    end

  end

end
