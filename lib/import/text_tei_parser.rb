module Import
  # Parse the TEI file for a text-type record (e.g. a novel).
  class TextTeiParser
    attr_reader :file

    def initialize(file)
      @file = file
    end

    # Return a ruby hash that contains all the interesting
    # values from the TEI file.
    def attributes
      attrs = {}
      xpath_map.each do |attr_name, attr_path|
        attrs[attr_name] = text_for(attr_path, xml)
      end
      attrs = attrs.merge(date_issued: issue_date,
                          identifier: identifier)
      attrs.reject { |_key, value| value.blank? }
    end

    def xml
      @xml ||= Nokogiri::XML(File.read(file))
    end

    # Map the name of the attribute to its xpath in the TEI file
    def xpath_map
      {
        title: '/*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title',
        creator: '/*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author',
        editor: '/*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:author',
        publisher: '/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:publisher',
        language: '/*/tei:teiHeader/tei:profileDesc/tei:langUsage/tei:language',
        extent: '/*/tei:teiHeader/tei:fileDesc/tei:extent',
        rights: '/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability',
        files: '//tei:text/tei:body//tei:pb/@facs'
      }
    end

    def namespaces
      { tei: "http://www.tei-c.org/ns/1.0" }
    end

    # Get the text for the element(s) at the given xpath within
    # the given node, and strip out extra whitespace.
    def text_for(xpath, node)
      node.xpath(xpath, namespaces).map do |element|
        element.text.strip
      end
    end

    def issue_date
      date = xml.xpath('/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:date', namespaces).first
      date.text.strip if date
    end

    def identifier
      id_node = xml.xpath('/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno', namespaces)
      id_node.map do |node|
        type = node.attribute('type') ? node.attribute('type').value : nil
        type = nil if type == 'dls'
        [type, node.text].compact.join(': ')
      end
    end
  end
end
