module OnCampusAccess
  OnCampus = 'on-campus'
  def on_campus_only_access?
    read_groups.include?('on-campus')
  end

  # overriding module Hydra::AccessControls::Visibility
  def visibility=(visibility)
    if visibility == OnCampus
      on_campus_visibility!
    else
      super
    end
  end

  def visibility
    if read_groups.include? OnCampus
      OnCampus
    else
      super
    end
  end

  def represented_visibility
    [Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_AUTHENTICATED,
     Hydra::AccessControls::AccessRight::PERMISSION_TEXT_VALUE_PUBLIC,
     OnCampus]
  end

  def on_campus_visibility!
    visibility_will_change! unless visibility == OnCampus
    replace_visibility = represented_visibility - [OnCampus]
    set_read_groups([OnCampus], replace_visibility)
  end
end
