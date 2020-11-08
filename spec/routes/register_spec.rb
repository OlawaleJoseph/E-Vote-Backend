require 'rails_helper'

describe 'Routing', type: :routing do
  it 'should route to /auth to registration#create' do
    should route(:post, 'api/v1/auth').to('devise_token_auth/registrations#create')
  end

  it 'should not route to /auth to another controller/action' do
    should_not route(:post, 'api/v1/auth').to('controller#action')
  end
end
