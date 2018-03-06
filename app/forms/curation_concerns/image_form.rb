module CurationConcerns
  class ImageForm < CommonForm
    self.model_class = ::Image
    self.terms += [:prevent_download]
  end
end
