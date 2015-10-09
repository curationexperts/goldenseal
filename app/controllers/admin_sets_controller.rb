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

  private

    def admin_set_params
      params.require(:admin_set).permit(
        :title, :identifier, :description, creator: [], contributor: [],
        subject: [], publisher: [], language: [])
    end
end
