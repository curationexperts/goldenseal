class ApplicationController < ActionController::Base
  rescue_from DeviseLdapAuthenticatable::LdapException do |exception|
    render :text => exception, :status => 500
  end
  helper Openseadragon::OpenseadragonHelper
  # Adds a few additional behaviors into the application controller
  include Blacklight::Controller

  # Adds CurationConcerns behaviors to the application controller.
  include Hydra::Controller::ControllerBehavior
  include CurationConcerns::ApplicationControllerBehavior
  include CurationConcerns::ThemedLayoutController
  with_themed_layout '1_column'


  # FIXME: move to curation_concerns#325
  rescue_from ActiveFedora::ObjectNotFoundError do |_exception|
    render file: "#{Rails.root}/public/404.html", format: :html, status: :not_found, layout: false
  end


  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
end
