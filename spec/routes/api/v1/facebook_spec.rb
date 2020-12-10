require 'rails_helper'

describe 'Fcaebook Omniauth', type: :routing do
  let(:path) { 'api/v1/auth/facebook' }
  let(:callback_path) { 'api/v1/auth/facebook/callback' }

  context 'Routing' do
    it "should route 'api/v1/auth/facebook' to omniauth_callbacks#passthru" do
      should route(:get, path).to('omniauth_callbacks#passthru', { format: :json })
      should route(:post, path).to('omniauth_callbacks#passthru', { format: :json })
    end

    it "should not route 'api/v1/auth/facebook' to another controller/action" do
      should_not route(:get, path).to('some#destroy', { format: :json })
      should_not route(:post, path).to('some#destroy', { format: :json })
    end

    it "should route 'api/v1/auth/facebook/callback' to omniauth_callbacks#facebook" do
      should route(:get, callback_path).to('omniauth_callbacks#facebook', { format: :json })
      should route(:post, callback_path).to('omniauth_callbacks#facebook', { format: :json })
    end

    it "should not route 'api/v1/auth/facebook/callback' to another controller/action" do
      should_not route(:get, callback_path).to('some#destroy', { format: :json })
      should_not route(:post, callback_path).to('some#destroy', { format: :json })
    end
  end
end
