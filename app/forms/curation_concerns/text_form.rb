module CurationConcerns
  class TextForm < CommonForm
    self.model_class = ::Text
    self.terms += [:tei_id]
  end
end

