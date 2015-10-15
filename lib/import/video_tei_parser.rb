# Parse the TEI file for a video record
module Import
  class VideoTeiParser < CommonTeiParser

    # Map the name of the attribute to its xpath in the TEI file
    def xpath_map
      { title: '/*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title',
        creator: '/*/tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:recordingStmt/tei:recording/tei:respStmt/tei:name',
      }
    end

    def issue_date_xpath
      '/*/tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date'
    end

  end
end
