module CurationConcerns
  class GenericFilesController < ApplicationController
    include CurationConcerns::GenericFilesControllerBehavior

    def additional_response_formats(format)
      format.vtt { render_vtt }
    end

    # Copied from curation_concerns, because there's no way to add extra response types yet.
    # TODO: Merge once https://github.com/projecthydra-labs/curation_concerns/pull/335 is merged
    # routed to /files/:id
    def show
      respond_to do |wants|
        wants.html do
          _, document_list = search_results(params, [:add_access_controls_to_solr_params, :find_one, :only_generic_files])
          curation_concern = document_list.first
          raise CanCan::AccessDenied unless curation_concern
          @presenter = show_presenter.new(curation_concern, current_ability)
        end
        wants.json do
          # load and authorize @curation_concern manually because it's skipped for html
          @generic_file = curation_concern_type.load_instance_from_solr(params[:id]) unless curation_concern
          authorize! :show, @generic_file
          render :show, status: :ok
        end
        additional_response_formats(wants)
      end
    end

    protected

      def render_vtt
        gf = ::GenericFile.find(params[:id])
        authorize! :show, gf
        file = gf.original_file
        if ['text/xml', 'application/xml'].include? file.mime_type
          render text: VTTService.create(file.content)
        else
          raise ActiveFedora::ObjectNotFoundError
        end
      end

      # TODO we can remove this when projecthydra-labs/curation_concerns#323 is merged.
      def generic_file_params
        params.require(:generic_file).permit(
          :visibility_during_embargo, :embargo_release_date, :visibility_after_embargo, :visibility_during_lease, :lease_expiration_date, :visibility_after_lease, :visibility, title: [])
      end
  end
end
