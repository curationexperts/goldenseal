class SpotlightExhibitRenderer < CurationConcerns::AttributeRenderer
  def li_value(value)
    link_to ERB::Util.h(value), options.fetch(:link_path)
  end
end
