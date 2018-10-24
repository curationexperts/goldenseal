module CurationConcerns
  class CommonForm < CurationConcerns::Forms::WorkForm
    include OnCampusAccess
    self.terms += [:admin_set_id, :editor, :sponsor, :funder, :researcher, :source, :identifier, :series, :extent, :note, :description_standard, :publication_place, :date_issued, :custom_metadatas]

    delegate :read_groups, :custom_metadatas, :custom_metadatas_attributes=, to: :model


    protected
    def self.build_permitted_params
      permitted = super
      permitted.delete({ custom_metadatas_attributes: [] })
      permitted << { custom_metadatas_attributes: [:id, :title, :value] }
      permitted
    end
  end
end

