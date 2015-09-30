module CurationConcerns
  class GenericFilesController < ApplicationController
    include CurationConcerns::GenericFilesControllerBehavior

    # Called by show() in CurationConcerns
    def additional_response_formats(format)
      format.vtt { render_vtt }
    end

    protected

      def render_vtt
        gf = ::GenericFile.find(params[:id])
        authorize! :show, gf
        file = gf.original_file
        if ['text/xml', 'application/xml'].include? file.mime_type
          render text: VTTService.create(file.content)
        else
          fail ActiveFedora::ObjectNotFoundError
        end
      end
  end
end
