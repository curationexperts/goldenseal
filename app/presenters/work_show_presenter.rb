class WorkShowPresenter < CurationConcerns::WorkShowPresenter
  include DisplayFields
  include ActionView::Helpers::UrlHelper

  def tei_id
    Array(solr_document['hasEncodedText_ssim']).first
  end

  def admin_set
    return unless admin_set_id
    "<tr><th>Collection</th><td>#{admin_set_link}</td></tr>".html_safe
  end

  private
    def admin_set_title
      ERB::Util.h(solr_document['admin_set_ssi'])
    end

    def admin_set_id
      solr_document['isPartOf_ssim']
    end

    def admin_set_link
      link_to admin_set_title, admin_set_path
    end

    def admin_set_path
      Rails.application.routes.url_helpers.admin_set_path(admin_set_id)
    end
end
