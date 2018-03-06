module CurationConcerns
  class AudioForm < TeiForm
    self.model_class = ::Audio
    self.terms += [:prevent_download]
  end
end
