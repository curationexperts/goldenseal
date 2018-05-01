module CurationConcerns::Forms
  class FileSetEditForm
    include HydraEditor::Form
    self.required_fields = [:title, :creator, :tag, :rights]

    self.model_class = ::FileSet

    self.terms = [:resource_type, :title, :creator, :contributor, :description,
                  :tag, :rights, :publisher, :date_created, :subject, :language,
                  :identifier, :based_near, :related_url,
                  :visibility_during_embargo, :visibility_after_embargo, :embargo_release_date,
                  :visibility_during_lease, :visibility_after_lease, :lease_expiration_date,
                  :visibility, :prevent_download]
  end
end