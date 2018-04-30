class TextIndexer < BaseWorkIndexer
  TEI_JSON = 'tei_json_tesim'

  def generate_solr_document
    super do |solr_doc|
      puts(ActionView::Base.full_sanitizer.sanitize(tei))
      solr_doc[TEI_JSON] = ActionView::Base.full_sanitizer.sanitize(tei) if object.tei
    end
  end
  
  def tei_to_json
    as_json = tei_as_json
    return unless as_json
    JSON.generate(as_json)
  end

  def tei
    @tei ||= object.tei.try(:original_file).try(:content)
  end
  
  def tei_as_json
    # OPTIMIZE: this could be indexed on the FileSet which
    # so that every index call wouldn't have to load the tei file.
    return unless tei
    TEIConverter.new(tei, object).as_json
  end
end
