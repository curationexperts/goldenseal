module Import
  class AudioImporter < CommonImporter

    # The type of record(s) this importer will create
    def record_class
      Audio
    end

    def parser
      AudioTeiParser
    end

  end
end
