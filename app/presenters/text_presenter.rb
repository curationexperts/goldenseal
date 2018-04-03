class TextPresenter < WorkShowPresenter
  include DisplayFields

  def tei?
    tei_as_json.present?
  end

  # TODO: this could be done as an AJAX call
  def tei_as_json
    @json ||= TeiForText.new(solr_document.to_model).to_json
  end
end
