# Parse the TEI file for a video record
module Import
  class VideoTeiParser < CommonTeiParser

    # Map the name of the attribute to its xpath in the TEI file
    def xpath_map
      { title: '/*/tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title',
      }
    end

  end
end
