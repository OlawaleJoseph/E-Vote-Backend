require 'rails_helper'

RSpec.describe 'Login', type: :request do
  context 'Validations' do
    let(:user) { create(:user) }
    let(:url) { '/api/v1/auth/login' }

    context '' do
      scenario 'should return 400 if email is absent' do
        user.email = ''
        login_user(user)
        expect(response).to have_http_status(401)
      end

      scenario 'should return 400 if email is invalid' do
        user.email = 'abc@wer.com'
        login_user(user)
        expect(response).to have_http_status(401)
        expect(json['error']).to eq('Invalid Email or password.')
      end

      scenario 'should return 400 if email is absent' do
        user.password = ''
        login_user(user)
        expect(response).to have_http_status(401)
      end

      scenario 'should return 400 if email is invalid' do
        user.password = 'password'
        login_user(user)
        expect(response).to have_http_status(401)
        expect(json['error']).to eq('Invalid Email or password.')
      end

      scenario 'should return no errors for valid credentials' do
        login_user(user)
        expect(response).not_to have_http_status(401)
        expect(json['error']).to be nil
      end

      scenario 'should return logged in user info' do
        login_user(user)
        expect(response).not_to have_http_status(401)
        expect(json['id']).to eq(user.id)
      end
    end
    context 'Token' do
      scenario 'should generate a token for successful login' do
        login_user(user)
        expect(response.headers['Authorization']).not_to be_nil
        expect(response.headers['Authorization'].split(' ').last).not_to be_nil
      end
    end
  end
end
