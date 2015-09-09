class TEIConverter
  include ActionView::Helpers::AssetTagHelper
  def initialize(source, target)
    @target = target
    @source = source
  end

  def as_json
    # First parsing will just mark up page breaks
    doc2 = intermediate()

    # second parsing will put the text between each break into divs
    tei_nodes = doc2.css('#tei-content')
    return { error: "Unable to parse TEI for this object." } if tei_nodes.empty?
    pages = [ ]
    current_element = {html: '' }
    page = 1
    tei_nodes.each do |tei_node|
      tei_node.children.each do |e|
        case e
        when Nokogiri::XML::Text
          next if e.to_s.strip == ''
          current_element[:html] << "<div>#{e.to_s}</div>".html_safe
        when Nokogiri::XML::Element
          # if the element is a page break. Add an image and a text blurb.
          next if e.name == 'br'
          if e.attr('class') == "pageheader"
            pages << current_element if page > 1
            current_element = { page: page, html: ''.html_safe }
            page += 1
            file_id = @target.id_for_filename(e.attr('data-image'))
            current_element[:image] = image_tag(Rails.application.routes.url_helpers.image_path(file_id, size: ',600')) if file_id
          end
          current_element[:html] << e.to_s.html_safe
        end
      end
    end
    pages << current_element# if page > 1
    #{ pages: pages, object: root.attr('data-object') }.with_indifferent_access
    { pages: pages, object: nil }.with_indifferent_access
  end

  private
    def intermediate
      doc = Nokogiri::XML(@source)
      xslt = Nokogiri::XSLT(File.read('lib/stylesheets/tei.xslt'))
      intermediate = xslt.transform(doc).to_xml
      Nokogiri::HTML(intermediate)
    end
end
