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

    # This can be removed when https://github.com/projecthydra-labs/curation_concerns/pull/376 is merged
    def deny_access(exception)
      if current_user && current_user.persisted?
        respond_to do |wants|
          wants.html do
            if [:show, :edit, :update, :destroy].include? exception.action
              render 'curation_concerns/base/unauthorized', status: :unauthorized
            else
              redirect_to root_url, alert: exception.message
            end
          end
          wants.json { render_json_response(response_type: :forbidden, message: exception.message) }
        end
      else
        session['user_return_to'.freeze] = request.url
        respond_to do |wants|
          wants.html { redirect_to new_user_session_path, alert: exception.message }
          wants.json { render_json_response(response_type: :unauthorized, message: exception.message) }
        end
      end
    end
end
