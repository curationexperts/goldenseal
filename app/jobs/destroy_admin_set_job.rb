class DestroyAdminSetJob < ActiveJob::Base
  queue_as :destroy_admin_set

  def perform(set_to_remove_id, set_to_move_to_id)
    admin_set_to_remove = AdminSet.find(set_to_remove_id)
    set_to_move_to = AdminSet.find(set_to_move_to_id)

    set_to_move_to.members << admin_set_to_remove.members
    set_to_move_to.save!
    admin_set_to_remove.destroy
  end
end

