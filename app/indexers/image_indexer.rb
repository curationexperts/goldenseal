class ImageIndexer < BaseWorkIndexer
  def generate_solr_document
    super do |solr_doc|
      begin
        solr_doc.merge! ImageInfo.new(object.representative).solr_document if object.representative
      rescue Blacklight::Exceptions::RecordNotFound
        Rails.logger.warn "Unable to index the representative image (#{object.representative}) for #{object.id}. If you are running 'reindex_everything', run it again once it finishes.  Otherwise RIIIF will be unable to find this image"
      end
    end
  end
end
