require 'rails_helper'

describe 'Routing', type: :routing do
  it 'should route api/v1/auth/login to sessions#create' do
    should route(:post, 'api/v1/auth/login').to('sessions#create', { format: :json })
  end

  it 'should not route api/v1/auth/login  to another controller/action' do
    should_not route(:post, 'api/v1/auth/login').to('controller#action')
  end
end
