# Parse the TEI file for a text-type record (e.g. a novel).
module Import
  class TextTeiParser < CommonTeiParser

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

    def issue_date_xpath
      '/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:biblFull/tei:publicationStmt/tei:date'
    end

  end
end
