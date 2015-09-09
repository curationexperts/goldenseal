class TextIndexer < BaseWorkIndexer
  TEI_JSON = 'tei_json_ss'

  def generate_solr_document
    super do |solr_doc|
      solr_doc[TEI_JSON] = tei_to_json if object.tei
    end
  end

  def tei_to_json
    as_json = tei_as_json
    return unless as_json
    JSON.generate(as_json)
  end

  def tei_as_json
    # OPTIMIZE: this could be indexed on the GenericFile which
    # so that every index call wouldn't have to load the tei file.
    tei = object.tei.original_file.try(:content)
    return unless tei
    TEIConverter.new(tei, object).as_json
  end
end
