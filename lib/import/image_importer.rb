# Import Image records using metadata from VRA files.
module Import
  class ImageImporter < CommonImporter

    # The type of record(s) this importer will create
    def record_class
      Image
    end

    def parser
      ImageVraParser
    end

  end
end
