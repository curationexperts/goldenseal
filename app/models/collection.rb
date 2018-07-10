class Collection < ActiveFedora::Base
  include ::CurationConcerns::CollectionBehavior
  include SpotlightExhibitable
  self.human_readable_type = 'Personal Collection'

  def default_filter_field
    "member_ids_ssim"
  end

  private
  def spotlight_exhibit_query
    Spotlight::Exhibit
      .where(exhibitable_id: self.id)
      .where(exhibitable_type: 'Collection')
  end
end
