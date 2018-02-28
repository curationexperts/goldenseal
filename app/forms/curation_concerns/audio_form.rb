module CurationConcerns
  class AudioForm < TeiForm
    self.model_class = ::Audio
    self.terms += [:downloadable]
  end
end
