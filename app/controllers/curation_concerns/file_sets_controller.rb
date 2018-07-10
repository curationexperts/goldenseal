module CurationConcerns
  class FileSetsController < ApplicationController
    include CurationConcerns::FileSetsControllerBehavior

    # Called by show() in CurationConcerns
    def additional_response_formats(format)
      format.vtt { render_vtt }
    end

    delegate :prevent_download, to: :solr_document

    protected

      # Overridden to use a local presenter implementation
      def show_presenter
        ::FileSetPresenter
      end

      def render_vtt
        gf = ::FileSet.find(params[:id])
        authorize! :show, gf
        file = gf.original_file
        if ['text/xml', 'application/xml'].include? file.mime_type
          render text: VTTService.create(file.content)
        else
          fail ActiveFedora::ObjectNotFoundError
        end
      end

      delegate :prevent_download, to: :solr_document
  end
end
