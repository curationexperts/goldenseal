# Parse the TEI file for a video record
module Import
  class VideoTeiParser < CommonTeiParser

    # Map the name of the attribute to its xpath in the TEI file
    def xpath_map
      { title: '/*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title',
        creator: '/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:recordingStmt/tei:recording/tei:respStmt/tei:name',
        contributor: '/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:recordingStmt/tei:recording/tei:respStmt/tei:name',
        publisher: '/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:publisher',
        description: '/*/tei:text/tei:front/tei:titlePage/tei:imprimatur',
        rights: '/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:availability',
        language: '/*/tei:teiHeader/tei:profileDesc/tei:langUsage/tei:language',
        date_created: '/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:recordingStmt/tei:recording/tei:date',
        publication_place: '/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:pubPlace',
      }
    end

    def issue_date_xpath
      '/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date'
    end

  end
end
