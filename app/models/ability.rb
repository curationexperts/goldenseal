class Ability
  include Hydra::Ability
  include CurationConcerns::Ability

  # Define any customized permissions here.
  def custom_permissions
    if admin?
      can [:confirm_delete], ActiveFedora::Base
      can [:allow_downloads, :prevent_downloads], AdminSet
    end

    can :read, Spotlight::HomePage
    can :read, Spotlight::Exhibit

    # Limits creating new objects to a specific group
    #
    # if user_groups.include? 'special_group'
    #   can [:create], ActiveFedora::Base
    # end
  end

  def add_to_collection
    return unless admin?
    can :collect, :all
  end
end
