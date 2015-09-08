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

  private

    def cached_groups(&block)
      update(group_list: yield, groups_list_expires_at: 1.day.from_now) if groups_need_update?
      group_list
    end

    def groups_need_update?
      groups_list_expires_at.blank? || groups_list_expires_at < Time.now
    end
end
