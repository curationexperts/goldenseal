module CurationConcerns
  class CommonForm < CurationConcerns::Forms::WorkForm
    self.terms += [:admin_set_id]
  end
end

