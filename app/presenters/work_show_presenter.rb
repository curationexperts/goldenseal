class WorkShowPresenter < CurationConcerns::GenericWorkShowPresenter
  include DisplayFields

  def tei_id
    '13'
  end
end
