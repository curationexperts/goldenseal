class Qa::LocalAuthorityEntry < ActiveRecord::Base
  belongs_to :local_authority

  def uri_editable?
    self.id.blank?
  end
end
