require 'rails_helper'

describe 'Google Omniauth', type: :routing do
  let(:callback_path) { '/api/v1/auth/google_oauth2/callback' }

  context 'Routing' do
    it "should route 'api/v1/auth/google_oauth2/callback' to omniauth_callbacks#google_oauth2" do
      should route(:get, callback_path).to('omniauth_callbacks#google_oauth2', { format: :json })
      should route(:post, callback_path).to('omniauth_callbacks#google_oauth2', { format: :json })
    end

    it "should not route 'api/v1/auth/google_oauth2/callback' to another controller/action" do
      should_not route(:get, callback_path).to('some#destroy', { format: :json })
      should_not route(:post, callback_path).to('some#destroy', { format: :json })
    end
  end
end
