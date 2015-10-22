# Parse the TEI file for an audio record
module Import
  class AudioTeiParser < VideoTeiParser

  #class AudioTeiParser < CommonTeiParser
    # TODO: For now the AudioTeiParser has the same behavior
    # as the VideoTeiParser.  Do we have any use case for
    # different behavior?
  end
end
