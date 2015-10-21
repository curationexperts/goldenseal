class PermissionBadge < CurationConcerns::PermissionBadge
  def dom_label_class
    return 'label-info' if @solr_document.on_campus?
    super
  end

  def link_title
    return 'On campus' if @solr_document.on_campus?
    super
  end
end
