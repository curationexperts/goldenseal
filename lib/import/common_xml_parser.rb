# Methods needed to parse an XML file
module Import
  class CommonXmlParser

    attr_reader :file

    def initialize(file)
      @file = file
    end

    # Return a ruby hash that contains all the interesting
    # values from the metadata file.
    def attributes
      attrs = {}
      xpath_map.each do |attr_name, attr_path|
        attrs[attr_name] = text_for(attr_path, xml)
      end
      attrs = attrs.merge(identifier: identifier,
                          date_issued: issue_date)
      attrs.reject { |_key, value| value.blank? }
    end

    def xml
      @xml ||= Nokogiri::XML(File.read(file))
    end

    # Get the text for the element(s) at the given xpath within
    # the given node, and strip out extra whitespace.
    def text_for(xpath, node)
      node.xpath(xpath, namespaces).map do |element|
        element.text.squish
      end
    end

    def xpath_map
      raise 'Please implement the xpath_map method'
    end

    def issue_date_xpath
      raise 'Please implement the issue_date_xpath method'
    end

    def namespaces
      raise 'Please implement the namespaces method'
    end

  end
end
