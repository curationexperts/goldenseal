module ExhibitPresenter
  extend ActiveSupport::Concern

  def edit_exhibit_path
    Spotlight::Engine.routes.url_helpers.edit_exhibit_path(spotlight_exhibit) if spotlight_exhibit 
  end

  def spotlight_exhibit_title
    spotlight_exhibit.title if spotlight_exhibit
  end

  def custom_metadata_fields
    []
  end

  def spotlight_exhibit
    raise "You should impliment this method when ExhibitPresenter is included"
  end
end
