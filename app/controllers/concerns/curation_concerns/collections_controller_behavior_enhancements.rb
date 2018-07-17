module CurationConcerns
  module CollectionsControllerBehaviorEnhancements
    extend ActiveSupport::Concern
    included do
      before_action :filter_docs_with_read_access!, except: [:show, :prevent_downloads, :allow_downloads]
      skip_load_and_authorize_resource only: [:show, :prevent_downloads, :allow_downloads]
    end

    def allow_downloads
      file_type = params[:file_type]
      collection = Collection.find(params[:id])
      toggle_prevent_download(collection, false, file_type)
      redirect_to collection_path(collection), notice: 'Collection was successfully updated.'
    end

    def prevent_downloads
      file_type = params[:file_type]
      collection = Collection.find(params[:id])
      toggle_prevent_download(collection, true, file_type)
      redirect_to collection_path(collection), notice: 'Collection was successfully updated.'
    end
  end
end
