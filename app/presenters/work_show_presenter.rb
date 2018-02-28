class WorkShowPresenter < CurationConcerns::WorkShowPresenter
  include DisplayFields
  include ActionView::Helpers::UrlHelper

  def tei_id
    Array(solr_document['hasTranscript_ssim']).first
  end

  def attribute_to_html(field, options = {})
    case field
    when :admin_set
      AdminSetRenderer.new(:admin_set, [admin_set_title], link_path: admin_set_path).render if admin_set_id
    else
      super
    end
  end

  private

    def admin_set_title
      ERB::Util.h(solr_document['admin_set_ssi'])
    end

    def admin_set_id
      solr_document['isPartOf_ssim']
    end

    def admin_set_path
      Rails.application.routes.url_helpers.admin_set_path(admin_set_id)
    end

    delegate :downloadable, to: :solr_document
end
