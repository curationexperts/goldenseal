module CurationConcerns
  class CommonForm < CurationConcerns::Forms::WorkForm
    include OnCampusAccess
    self.terms += [:admin_set_id, :editor, :sponsor, :funder, :researcher, :source, :identifier, :series, :extent, :note, :description_standard, :publication_place, :date_issued]

    delegate :read_groups, to: :model
  end
end

