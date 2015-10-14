module InAdminSet
  extend ActiveSupport::Concern

  included do
    belongs_to :admin_set, predicate: ::RDF::DC.isPartOf
  end
end
