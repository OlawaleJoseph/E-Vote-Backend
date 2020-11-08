Rails.application.routes.draw do
  namespace 'api' do
    namespace 'v1' do
      mount_devise_token_auth_for 'User', at: 'auth', defaults: { format: :json },
                                          path_names: {
                                            registration: 'register',
                                            sign_in: 'login',
                                            sign_out: 'logout'
                                          }
      # controllers: {
      #   sessions: 'sessions',
      #   registrations: 'registrations'
      # }
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
