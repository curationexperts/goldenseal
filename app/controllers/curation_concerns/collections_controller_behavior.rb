module CurationConcerns
  module CollectionsControllerBehavior
    extend ActiveSupport::Concern
    include Hydra::CollectionsControllerBehavior
    include Hydra::Controller::SearchBuilder

    included do
      before_action :filter_docs_with_read_access!, except: [:show, :enable_downloads, :disable_downloads]
      self.search_params_logic += [:add_access_controls_to_solr_params, :add_advanced_parse_q_to_solr]
      layout 'curation_concerns/1_column'
      skip_load_and_authorize_resource only: [:show, :enable_downloads, :disable_downloads]
    end

    def new
      super
      form
    end

    def edit
      super
      form
    end

    def show
      presenter
      super
    end

    # overriding the method in Hydra::Collections so the search builder can find the collection
    def collection
      action_name == 'show' ? @presenter : @collection
    end

    def enable_downloads
      collection = Collection.find(params[:id])
      toggle_downloadable(collection, true)
      redirect_to collection_path(collection), notice: 'Collection was successfully updated.'
    end

    def disable_downloads
      collection = Collection.find(params[:id])
      toggle_downloadable(collection, false)
      redirect_to collection_path(collection), notice: 'Collection was successfully updated.'
    end

    protected

      def toggle_downloadable(collection, value)
        authorize! :edit, collection 
        videos = collection.works.select{ |work| work.class == Video }
        videos.each do |video|
          actor = CurationConcerns::CurationConcern.actor(video, current_user, { downloadable: value }) 
          actor.update 
        end
      end

      def filter_docs_with_read_access!
        super
        flash.delete(:notice) if flash.notice == 'Select something first'
      end

      def presenter
        @presenter ||= begin
          _, document_list = search_results(params, self.class.search_params_logic + [:find_one])
          curation_concern = document_list.first
          raise CanCan::AccessDenied unless curation_concern
          presenter_class.new(curation_concern, current_ability)
        end
      end

      def presenter_class
        CurationConcerns::CollectionPresenter
      end

      def collection_member_search_builder_class
        CurationConcerns::SearchBuilder
      end

      def collection_params
        form_class.model_attributes(params[:collection])
      end

      def query_collection_members
        params[:q] = params[:cq]
        super
      end

      def after_destroy(id)
        respond_to do |format|
          format.html { redirect_to collections_path, notice: 'Collection was successfully deleted.' }
          format.json { render json: { id: id }, status: :destroyed, location: @collection }
        end
      end

      def form
        @form ||= form_class.new(@collection)
      end

      def form_class
        CurationConcerns::Forms::CollectionEditForm
      end

      # Include 'catalog' and 'curation_concerns/base' in the search path for views
      def _prefixes
        @_prefixes ||= super + ['catalog', 'curation_concerns/base']
      end
  end
end
