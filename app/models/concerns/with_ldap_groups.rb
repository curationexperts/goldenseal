module WithLdapGroups
  extend ActiveSupport::Concern

  included do
    serialize :group_list, Array
  end

  # Groups that user is a member of. Cached locally for 1 day
  def groups
    return [] if new_record?
    cached_groups do
      fetch_groups!
    end
  end

  # get the groups from LDAP and update the local cache
  def fetch_groups!
    new_groups = ldap_groups.map do |dn|
      /^cn=([^,]+),/.match(dn)[1]
    end
  end

  # we're overriding the method provided by devise-ldap in order to
  # query 'group' instead of 'uniqueMember'
  # see https://github.com/cschiewek/devise_ldap_authenticatable/issues/189
  def ldap_groups
    connection = Devise::LDAP::Adapter.ldap_connect(login_with)
    admin_ldap = Devise::LDAP::Connection.admin
    dn = connection.dn

    DeviseLdapAuthenticatable::Logger.send("MY uniq Getting groups for #{dn}")
    filter = Net::LDAP::Filter.eq("member", dn)

    group_base = connection.instance_variable_get(:@group_base)
    admin_ldap.search(filter: filter, base: group_base).collect(&:dn)
  end

  private

    def cached_groups(&block)
      update(group_list: yield, groups_list_expires_at: 1.day.from_now) if groups_need_update?
      group_list
    end

    def groups_need_update?
      groups_list_expires_at.blank? || groups_list_expires_at < Time.now
    end
end
