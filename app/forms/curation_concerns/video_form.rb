module CurationConcerns
  class VideoForm < TeiForm
    self.model_class = ::Video
    self.terms += [:prevent_download]
  end
end
