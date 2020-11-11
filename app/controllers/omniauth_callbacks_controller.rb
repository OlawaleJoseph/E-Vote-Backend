class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env['omniauth.auth'])
    return unless @user.persisted?

    sign_in @user, event: :authentication
    render json: @user, status: 200
  end

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])
    return unless @user.persisted?

    sign_in @user, event: :authentication
    render json: @user, status: 200
  end

  def failure
    render json: {
      errors: {
        message: 'Authentication failed. Kindly register or login'
      }
    }, status: 401
  end
end
