# Methods needed to parse TEI files
module Import
  module ParseTei

    def namespaces
      { tei: "http://www.tei-c.org/ns/1.0" }
    end

    # Return a ruby hash that contains all the interesting
    # values from the metadata file.
    def attributes
      attrs = super
      attrs = attrs.merge(identifier: identifier,
                          date_issued: issue_date)
      attrs.reject { |_key, value| value.blank? }
    end

    # Read identifer from 2 places: the root xml:id and the
    # 'idno' node.
    def identifier
      id_node = xml.xpath('/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno', namespaces)
      ids = id_node.map do |node|
        type = node.attribute('type') ? node.attribute('type').value : nil
        type = nil if type.match(/dls/i)
        [type, node.text].compact.join(': ')
      end

      root_id = xml.xpath('/*/@xml:id', namespaces).text
      root_id = nil if root_id.blank?
      (Array(root_id) + ids).compact.uniq
    end

    def issue_date
      date = xml.xpath(issue_date_xpath, namespaces).first
      date.text.strip if date
    end

    def issue_date_xpath
      raise 'Please implement the issue_date_xpath method'
    end

  end
end
