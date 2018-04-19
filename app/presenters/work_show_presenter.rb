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

  def respond_to?(method)
    has_native = super
    return true if has_native

    # look for custom metadata
    key = "#{method}_ssi"
    return false unless solr_document.keys.include?(key)

    self.class.send :define_method, method do
      solr_document[key]
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
end
