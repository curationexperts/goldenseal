# Parse the TEI file for a text-type record (e.g. a novel).
module Import
  class TextTeiParser < CommonTeiParser

    # Return a ruby hash that contains all the interesting
    # values from the TEI file.
    def attributes
      attrs = super
      attrs = attrs.merge(date_issued: issue_date)
      attrs.reject { |_key, value| value.blank? }
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

    def issue_date
      date = xml.xpath('/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:date', namespaces).first
      date.text.strip if date
    end

  end
end
