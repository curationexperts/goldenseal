module CurationConcerns
  class ImageForm < CommonForm
    self.model_class = ::Image
    self.terms += [:downloadable]
  end
end
