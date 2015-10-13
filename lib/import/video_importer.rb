# Import Video records using metadata from TEI files.
module Import
  class VideoImporter < CommonImporter

    # The type of record(s) this importer will create
    def record_class
      Video
    end

    def parser
      VideoTeiParser
    end

  end
end
