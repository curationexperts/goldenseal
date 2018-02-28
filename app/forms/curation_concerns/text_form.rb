module CurationConcerns
  class TextForm < TeiForm
    self.model_class = ::Text
    self.terms += [:downloadable]
  end
end

