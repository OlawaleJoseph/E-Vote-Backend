require 'rails_helper'

describe 'Routing', type: :routing do
  it 'should route to /auth to registration#create' do
    should route(:post, 'api/v1/auth/register').to('registrations#create', { format: :json })
  end

  it 'should not route to /auth to another controller/action' do
    should_not route(:post, 'api/v1/auth/register').to('controller#action')
  end
end
