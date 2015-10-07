module Import
  class FileWithName < File
    # This class is a shim to make the importers work with the
    # FileSetActor.  Currently the FileSetActor is
    # expecting a file uploaded using a controller
    # (ActionDispatch::Http::UploadedFile) instead of a file
    # from the file system.

    def original_filename
      File.basename(self)
    end

    def content_type
      MIME::Types.type_for(File.extname(self)).first.content_type
    end
  end
end
