module CurationConcerns
  class GenericFilesController < ApplicationController
    include CurationConcerns::GenericFilesControllerBehavior

    def show
      super
      respond_to do |wants|
        wants.html { }
        wants.vtt { render_vtt }
      end
    end

    protected

      def render_vtt
        gf = ::GenericFile.find(@presenter.id)
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
