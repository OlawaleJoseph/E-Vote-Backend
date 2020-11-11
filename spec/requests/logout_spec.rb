require 'rails_helper'

RSpec.describe 'Logout', type: :request do
  context 'Authorization token' do
    before(:each) do
      login_user(create(:user))
      delete '/api/v1/logout'
    end
    scenario 'should be nil' do
      expect(response.headers['Authorization']).to be_nil
      expect(response).to have_http_status(204)
    end
  end
end
