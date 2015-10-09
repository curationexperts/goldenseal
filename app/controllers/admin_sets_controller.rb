class AdminSetsController < ApplicationController
  load_and_authorize_resource

  def new
  end

  def create
    if @admin_set.save
      redirect_to @admin_set
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @admin_set.update(admin_set_params)
      redirect_to @admin_set
    else
      render :new
    end
  end

  def confirm_delete
    @form = DeleteForm.new(@admin_set)
  end

  def destroy
    DestroyAdminSetJob.perform_later(@admin_set.id, params[:admin_set].fetch(:admin_set_id))
    redirect_to root_path, notice: "#{@admin_set.title} has been queued for removal. This may take several minutes."
  end

  private

    def admin_set_params
      params.require(:admin_set).permit(
        :title, :identifier, :description, creator: [], contributor: [],
        subject: [], publisher: [], language: [])
    end
end
