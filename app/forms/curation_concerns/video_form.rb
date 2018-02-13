module CurationConcerns
  class VideoForm < TeiForm
    self.model_class = ::Video
    self.terms += [:downloadable]
  end
end
