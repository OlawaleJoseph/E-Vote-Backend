class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name username])
  end
end
