class TextPresenter < WorkShowPresenter
  include DisplayFields

  def tei?
    solr_document.key?(TextIndexer::TEI_JSON)
  end

  def tei_as_json
    solr_document.fetch(TextIndexer::TEI_JSON)
  end
end
