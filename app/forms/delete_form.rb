class DeleteForm
  include Hydra::Presenter

  attr_accessor :admin_set_id

  def alterative_admin_sets
    AdminSet.all.to_a.reject { |as| as.id == model.id }
  end
end
