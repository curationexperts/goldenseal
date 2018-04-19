class CurationConcerns::VideosController < ApplicationController
  include CurationConcerns::CurationConcernController

  include AttachFiles
  before_filter :add_attachments_to_files, only: :create

  set_curation_concern_type Video

  def show_presenter
    ::WorkShowPresenter
  end

  # def setup_form
    # super
    # byebug
  # end

  def build_form
    super
    if @form.model.admin_set
      existing_custom_metadatas = @form.model.custom_metadatas.collect(&:title)
      @form.model.admin_set.spotlight_exhibit.custom_fields.each do |custom_field|
        unless existing_custom_metadatas.include? custom_field.field
          @form.model.custom_metadatas.build(title: custom_field.slug.humanize)
        end
      end
    end
  end
end
