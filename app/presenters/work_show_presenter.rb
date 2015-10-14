class WorkShowPresenter < CurationConcerns::WorkShowPresenter
  include DisplayFields

  def tei_id
    Array(solr_document['hasEncodedText_ssim']).first
  end

  def admin_set
    solr_document['admin_set_ssi']
  end
end
