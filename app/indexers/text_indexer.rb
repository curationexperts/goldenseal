class TextIndexer < ActiveFedora::IndexingService
  TEI_JSON = 'tei_json_ss'

  def generate_solr_document
    super do |solr_doc|
      solr_doc[TEI_JSON] = tei_as_json
    end
  end

  def tei_as_json
    TEIConverter.new(object.tei.content, object).to_json
  end
end
