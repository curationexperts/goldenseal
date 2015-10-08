module CurationConcernsHelper
  include ::BlacklightHelper
  include CurationConcerns::MainAppHelpers

  # Override for AdminSets
  def url_for_document(doc, _options = {})
    case doc.fetch('has_model_ssim').first
    when AdminSet.to_class_uri
      admin_set_path doc.id
    else
      super
    end
  end

  def track_admin_set_path(*args)
    track_solr_document_path(*args)
  end
end
