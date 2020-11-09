Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1, defaults: { format: :json } do
      root to: 'home#index'
      devise_for :users,
                 path: '',
                 path_names: {
                   sign_in: 'auth/login',
                   sign_out: 'logout',
                   registration: 'auth/register'
                 },
                 controllers: {
                   sessions: 'sessions',
                   registrations: 'registrations',
                   confirmations: 'confirmations'
                 }
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
