require 'rails_helper'

RSpec.describe 'SignUp', type: :request do
  context 'Validations' do
    let(:parameters) do
      { first_name: 'Jane',
        last_name: 'Doe',
        username: 'janedoe',
        email: 'jane@example.com',
        password: 'Password1',
        confirm_password: 'Password1' }
    end
    let(:url) { post '/api/v1/auth/register', params: parameters }

    scenario 'should return 400 if first_name is absent' do
      parameters[:first_name] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json['errors']).to have_key('first_name')
    end

    scenario 'should return 400 if last_name is absent' do
      parameters[:last_name] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json['errors']).to have_key('last_name')
    end

    scenario 'should return 400 if email is absent' do
      parameters[:email] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json['errors']).to have_key('email')
    end

    scenario 'should return 400 if first_name is absent' do
      parameters[:password] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json['errors']).to have_key('password')
    end

    scenario 'should return 400 if first_name is absent' do
      parameters[:username] = nil
      url
      json = JSON.parse(response.body)
      expect(response).to have_http_status(400)
      expect(json['errors']).to have_key('username')
    end

    scenario 'should return 201 if all parameters are valid' do
      url
      json = JSON.parse(response.body)
      expect(response.status).to eq(201)
      expect(json['errors']).to be_nil
    end
  end
  context 'Mail Verification' do
    let(:parameters) do
      { first_name: 'Jane',
        last_name: 'Doe',
        username: 'janedoe',
        email: 'jane@example.com',
        password: 'Password1',
        confirm_password: 'Password1' }
    end
    let(:url) { post '/api/v1/auth/register', params: parameters }
    scenario 'should return 201 if all parameters are valid' do
      expect { url }.to change { ActionMailer::Base.deliveries.size }.by(1)
    end
  end
end
