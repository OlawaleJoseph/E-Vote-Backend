require 'rails_helper'

describe 'Polls', type: :routing do
  it 'should route /api/v1/auth/polls to API::V1:PollsController#create' do
    should route(:post, api_v1_polls_path).to('api/v1/polls#create', { format: :json })
  end

  it 'should not route /api/v1/auth/polls to another controller/action' do
    should_not route(:post, 'api_v1_polls_path').to('controller#action')
  end

  it 'should route /api/v1/polls to API::V1:PollsController#index' do
    should route(:get, api_v1_polls_path).to('api/v1/polls#index', { format: :json })
  end

  it 'should not route /api/v1/polls to controller#index' do
    should_not route(:get, api_v1_polls_path).to('controller#index', { format: :json })
  end

  it 'should route /api/v1/polls/1 to API::V1:PollsController#show' do
    should route(:get, api_v1_poll_path(1)).to('api/v1/polls#show', id: 1, format: :json)
  end

  it 'should not route /api/v1/polls/1 to controller#show' do
    should_not route(:get, api_v1_poll_path(1)).to('controller#show', { format: :json })
  end
end
