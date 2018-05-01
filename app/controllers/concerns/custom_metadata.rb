module CustomMetadata
  extend ActiveSupport::Concern

  def build_form
    super
    if @form.model.admin_set
      existing_custom_metadatas = @form.model.custom_metadatas.collect{|d| d.title.titleize}
      @form.model.admin_set.spotlight_exhibit.custom_fields.each do |custom_field|
        unless existing_custom_metadatas.include? custom_field.configuration["label"]
          @form.model.custom_metadatas.build(title: custom_field.slug.humanize)
        end
      end
    end
  end
end
