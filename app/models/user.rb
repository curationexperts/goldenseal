class User < ActiveRecord::Base

  include Blacklight::User # Connects this user object to Blacklights Bookmarks.
  include CurationConcerns::User
  include Hydra::User
  include Spotlight::User  

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable

  # Fetch groups from LDAP. Must come after `devise` call.
  if ENV['SKIP_LDAP'] && Rails.env.development?
    def groups
      ['admin']
    end
  else
    include WithLdapGroups
  end

  def email
    "test@example.com"
  end


  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    username
  end
end
