class Collection < ActiveFedora::Base
  include ::CurationConcerns::CollectionBehavior

  self.human_readable_type = 'Personal Collection'
end
