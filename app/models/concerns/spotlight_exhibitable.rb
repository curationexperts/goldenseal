module SpotlightExhibitable
  extend ActiveSupport::Concern

  included do
    after_create :create_spotlight_exhibit
    before_save :update_spotlight_exhibit
  end

  def spotlight_exhibit
    @spotlight_exhibit ||= spotlight_exhibit_query.first
  end

  def create_spotlight_exhibit
    spotlight_exhibit_query.first_or_create do |exhibit|
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

  def spotlight_exhibit_query 
    raise "This method must be implimented when this module is included."
  end
end
