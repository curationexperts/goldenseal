class AddGroupsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :group_list, :text
    add_column :users, :groups_list_expires_at, :datetime
  end
end
