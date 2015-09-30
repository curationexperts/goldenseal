class ImageIndexer < BaseWorkIndexer
  def generate_solr_document
    super do |solr_doc|
      solr_doc.merge! ImageInfo.new(object.representative).solr_document if object.representative
    end
  end
end
