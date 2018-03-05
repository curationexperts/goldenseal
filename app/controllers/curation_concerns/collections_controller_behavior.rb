module CurationConcerns
  module CollectionsControllerBehavior
    extend ActiveSupport::Concern
    include Hydra::CollectionsControllerBehavior
    include Hydra::Controller::SearchBuilder

    included do
      before_action :filter_docs_with_read_access!, except: [:show, :prevent_downloads, :allow_downloads]
      self.search_params_logic += [:add_access_controls_to_solr_params, :add_advanced_parse_q_to_solr]
      layout 'curation_concerns/1_column'
      skip_load_and_authorize_resource only: [:show, :prevent_downloads, :allow_downloads]
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

    protected

      def toggle_prevent_download(collection, value, file_type)
        authorize! :edit, collection
        case file_type
        when 'video'
          works = collection.works.select{ |work| work.class == Video }
        when 'text'
          works = collection.works.select{ |work| work.class == Text }
        when 'audio' 
          works = collection.works.select{ |work| work.class == Audio }
        when 'image'
          works = collection.works.select{ |work| work.class == Image }
        when 'all'
          works = collection.works
        end

        works.each do |work|
          actor = CurationConcerns::CurationConcern.actor(work, current_user, { prevent_download: value }) 
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
