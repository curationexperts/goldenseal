class AdminSetsController < ApplicationController
  include Blacklight::Base
  include Hydra::Controller::SearchBuilder
  include Downloads
  copy_blacklight_config_from(CatalogController)
  load_and_authorize_resource except: :show

  def new
    @form = AdminSetForm.new(@admin_set)
  end

  def create
    @admin_set.id = Array(@admin_set.identifier).first
    if @admin_set.save
      redirect_to @admin_set
    else
      render :new
    end
  end

  def show
    _, document_list = search_results(params, CatalogController.search_params_logic + [:find_one])
    curation_concern = document_list.first
    raise CanCan::AccessDenied.new(nil, :show) unless curation_concern
    @presenter = AdminSetPresenter.new(curation_concern)
  end

  def edit
    @form = AdminSetForm.new(@admin_set)
  end

  def update
    if @admin_set.update(admin_set_params)
      redirect_to @admin_set
    else
      render :new
    end
  end

  def confirm_delete
    @form = DeleteAdminSetForm.new(@admin_set)
  end

  def destroy
    DestroyAdminSetJob.perform_later(@admin_set.id, params[:admin_set].fetch(:admin_set_id))
    redirect_to root_path, notice: "#{@admin_set.title} has been queued for removal. This may take several minutes."
  end

  def allow_downloads
    toggle_prevent_download(@admin_set, false, params[:file_type])
    redirect_to @admin_set, notice: 'Collection was successfully updated.'
  end

  def prevent_downloads
    toggle_prevent_download(@admin_set, true, params[:file_type])
    redirect_to @admin_set, notice: 'Collection was successfully updated.'
  end

  private
    def admin_set_params
      AdminSetForm.model_attributes(params[:admin_set])
    end
end
