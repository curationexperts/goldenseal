module Import
  class CommonTeiParser

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
      attrs.reject { |_key, value| value.blank? }
    end

    def xml
      @xml ||= Nokogiri::XML(File.read(file))
    end

    def namespaces
      { tei: "http://www.tei-c.org/ns/1.0" }
    end

    # Get the text for the element(s) at the given xpath within
    # the given node, and strip out extra whitespace.
    def text_for(xpath, node)
      node.xpath(xpath, namespaces).map do |element|
        element.text.strip.gsub(/\s*\n\s*/, " ")
      end
    end

    def xpath_map
      raise 'Please implement the xpath_map method'
    end

  end
end
