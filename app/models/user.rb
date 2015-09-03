class User < ActiveRecord::Base
  # Connects this user object to Hydra behaviors.
  include Hydra::User
  # Connects this user object to Curation Concerns behaviors.
  include CurationConcerns::User

  # Connects this user object to Blacklights Bookmarks.
  include Blacklight::User

  # Fetch groups from LDAP
  include WithLdapGroups

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable

  # Method added by Blacklight; Blacklight uses #to_s on your
  # user class to get a user-displayable login/identifier for
  # the account.
  def to_s
    username
  end
end
