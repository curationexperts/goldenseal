class AddExhibitsForCollections < ActiveRecord::Migration
  def change
    add_column :spotlight_exhibits, :exhibitable_id, :string
    add_column :spotlight_exhibits, :exhibitable_type, :string
    add_index :spotlight_exhibits, :exhibitable_type
    add_index :spotlight_exhibits, :exhibitable_id 
  end
end
