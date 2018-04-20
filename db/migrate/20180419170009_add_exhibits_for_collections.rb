class AddExhibitsForCollections < ActiveRecord::Migration
  def change
    rename_column :spotlight_exhibits, :admin_set_id, :exhibitable_id
    add_column :spotlight_exhibits, :exhibitable_type, :string
  end
end
