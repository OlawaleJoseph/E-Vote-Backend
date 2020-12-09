class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  respond_to :json

  before_action :configure_permitted_parameters, if: :devise_controller?

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[first_name last_name username])
  end

  def verify_token!
    raise JWT::VerificationError if request.headers['Authorization'].nil?

    token = request.headers['Authorization'].split(' ').last
    JWT.decode(token, Rails.application.credentials[:devise][:JWT_SECRET_KEY], true).first
  rescue JWT::DecodeError, JWT::VerificationError
    render json: { errors: { message: 'Kindly login or register' } }, status: 401
  end

  def display_error(status, errors)
    render json: { errors: errors }, status: status
  end

  def forbidden
    render json: { errors: { message: 'You are not allowed to perform this operation' } }, status: 403
  end
end
