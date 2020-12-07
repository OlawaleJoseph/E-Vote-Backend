require 'rails_helper'

describe 'Polls', type: :routing do
  it 'should route /api/v1/auth/polls to API::V1:PollsController#create' do
    should route(:post, api_v1_polls_path).to('api/v1/polls#create', { format: :json })
  end

  it 'should not route /api/v1/auth/polls to another controller/action' do
    should_not route(:post, 'api_v1_polls_path').to('controller#action')
  end
end
