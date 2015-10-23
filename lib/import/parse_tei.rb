# Methods needed to parse TEI files
module Import
  module ParseTei

    def namespaces
      { tei: "http://www.tei-c.org/ns/1.0" }
    end

    def identifier
      id_node = xml.xpath('/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno', namespaces)
      id_node.map do |node|
        type = node.attribute('type') ? node.attribute('type').value : nil
        type = nil if type.match(/dls/i)
        [type, node.text].compact.join(': ')
      end
    end

    def issue_date
      date = xml.xpath(issue_date_xpath, namespaces).first
      date.text.strip if date
    end

  end
end
