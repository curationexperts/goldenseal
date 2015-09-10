class WorkShowPresenter < CurationConcerns::GenericWorkShowPresenter
  include DisplayFields

  def tei_id
    solr_document['hasEncodedText_ssim'].first
  end
end
