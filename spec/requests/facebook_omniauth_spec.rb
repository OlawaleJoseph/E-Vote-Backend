require 'rails_helper'
RSpec.describe 'Facebook Auth', type: :request do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  end

  before(:each) do
    OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
                                                                    provider: 'facebook',
                                                                    uid: '123545',
                                                                    info: {
                                                                      first_name: 'Andrea',
                                                                      last_name: 'Del Rio',
                                                                      email: 'test@example.com'
                                                                    },
                                                                    credentials: {
                                                                      token: '123456',
                                                                      expires_at: Time.now + 1.week
                                                                    }
                                                                  })
  end

  let(:url) { get '/api/v1/auth/facebook/callback' }

  context 'register' do
    scenario 'after successful facebook authentication' do
      expect { url }.to change { User.count }.by(1)
      expect(response.status).to eq(200)
    end

    scenario 'should not register if facebook authentication failed' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_facebook
      expect { url }.to change { User.count }.by(0)
      expect(response.status).to eq(401)
    end
  end

  context 'login' do
    before do
      user = create :user, { email: 'test@example.com' }
      user.confirm
    end

    scenario 'after successful facebook authentication' do
      expect { url }.not_to(change { User.count })
      expect(response.status).to eq(200)
    end

    scenario 'should not register if facebook authentication failed' do
      OmniAuth.config.mock_auth[:facebook] = :invalid_facebook
      expect { url }.to change { User.count }.by(0)
      expect(response.status).to eq(401)
    end
  end
end
