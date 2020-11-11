require 'rails_helper'

RSpec.describe 'Gmail Auth', type: :request do
  before do
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  end

  before(:each) do
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                         provider: 'google',
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

  let(:url) { get '/api/v1/auth/google_oauth2/callback' }

  context 'register' do
    scenario 'after successful google authentication' do
      expect { url }.to change { User.count }.by(1)
      expect(response.status).to eq(200)
    end

    scenario 'should not register if google authentication failed' do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_gmail
      expect { url }.to change { User.count }.by(0)
      expect(response.status).to eq(401)
    end
  end

  context 'login' do
    before do
      user = create :user, { email: 'test@example.com' }
      user.confirm
    end

    scenario 'after successful google authentication' do
      expect { url }.not_to(change { User.count })
      expect(response.status).to eq(200)
    end

    scenario 'should not register if google authentication failed' do
      OmniAuth.config.mock_auth[:google_oauth2] = :invalid_gmail
      expect { url }.to change { User.count }.by(0)
      expect(response.status).to eq(401)
    end
  end
end
