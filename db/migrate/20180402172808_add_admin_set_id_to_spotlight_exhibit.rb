class AddAdminSetIdToSpotlightExhibit < ActiveRecord::Migration
  def self.up
    add_column :spotlight_exhibits, :admin_set_id, :string

    AdminSet.all.each do |admin_set|
      Spotlight::Exhibit.create title: admin_set.title, admin_set_id: admin_set.id
    end
  end

  def self.down
    Spotlight::Exhibit.where.not(admin_set_id: nil).destroy_all
    remove_column :spotlight_exhibits, :admin_set_id
  end
end
