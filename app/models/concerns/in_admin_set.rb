module InAdminSet
  extend ActiveSupport::Concern

  included do
    belongs_to :admin_set, predicate: ActiveFedora::RDF::Fcrepo::RelsExt.hasCollectionMember
  end
end
