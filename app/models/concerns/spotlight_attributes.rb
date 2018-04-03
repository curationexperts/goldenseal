module SpotlightAttributes
  extend ActiveSupport::Concern

  # TODO: this needs paperclip like behavior
  #   from spotlight: app/controllers/concerns/spotlight/base.rb
  #      thumbnails: doc.spotlight_image_versions.try(:thumb) || doc[blacklight_config.index.thumbnail_field],
  #      full_image_url: doc.spotlight_image_versions.try(:full).try(:first),
  #      full_images: doc.spotlight_image_versions.try(:full),
  #      image_versions: doc.spotlight_image_versions.image_versions(:thumb, :full),
  included do
    property :spotlight_image_versions, predicate: ::RDF::Vocab::DC.abstract, multiple: true do |index|
      index.as :stored_sortable
    end
  end
end
