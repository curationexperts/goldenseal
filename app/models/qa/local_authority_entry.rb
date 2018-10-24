class Qa::LocalAuthorityEntry < ActiveRecord::Base
  belongs_to :local_authority

  validates :uri, format: { with: /\Ahttp[s]?:\/\/.+/, message: 'should start with "http://"' }

  def uri_editable?
    self.id.blank?
  end
end
