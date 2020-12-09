require 'rails_helper'

RSpec.describe 'Api::V1::Polls', type: :request do
  context 'Polls Creation' do
    user = nil
    poll = nil
    token = nil
    before do
      user = create :user
      token = login_user(user)
    end

    before(:each) do
      poll = {
        "title": 'Test',
        "info": 'Testing with Rspec',
        "restricted": false,
        "start_date": DateTime.now + 2,
        "end_date": DateTime.now + 3,
        "poll_questions_attributes": [
          {
            "content": 'Question',
            "poll_answers_attributes": [
              {
                "content": 'First Answer'
              },
              {
                "content": 'Second Answer'
              }
            ]
          }
        ]
      }
    end
    let(:visit_with_headers) { post '/api/v1/polls', params: poll, headers: headers(token) }
    let(:visit_without_headers) { post '/api/v1/polls', params: poll }
    let(:visit_with_invalid_token) { post '/api/v1/polls', params: poll, headers: headers('invalidtoken') }

    scenario 'should return 403 if no token is given' do
      visit_without_headers

      res = json
      expect(response).to have_http_status(401)
      expect(response).not_to have_http_status(200)
      expect(res['errors']['message']).to eq('Kindly login or register')
    end

    scenario 'should return 403 if token is invalid' do
      visit_with_invalid_token

      res = json
      expect(response).to have_http_status(401)
      expect(response).not_to have_http_status(200)
      expect(res['errors']['message']).to eq('Kindly login or register')
    end

    scenario 'missing title field' do
      poll[:title] = nil
      visit_with_headers
      res = json

      expect(response).to have_http_status(422)
      expect(res['errors']).to include('title')
      expect(res['errors']['title']).to include("can't be blank")
    end

    scenario 'invalid title field' do
      poll[:title] = 'ni'
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('title')
      expect(res['errors']['title']).to include('is too short (minimum is 3 characters)')
    end

    scenario 'missing info field' do
      poll[:info] = nil
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('info')
      expect(res['errors']['info']).to include("can't be blank")
    end

    scenario 'invalid info field' do
      poll[:info] = 'ni'
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('info')
      expect(res['errors']['info']).to include('is too short (minimum is 3 characters)')
    end

    scenario 'missing start date field' do
      poll[:start_date] = nil
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('start_date')
      expect(res['errors']['start_date']).to include("can't be blank")
    end

    scenario 'invalid start date field' do
      poll[:start_date] = 'invalid date'
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('start_date')
    end

    scenario 'start date equals end date' do
      poll[:start_date] = poll[:end_date]
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('start_date')
      expect(res['errors']['start_date']).to include("start date can't be equal to end date")
    end

    scenario 'start date farther than end date' do
      poll[:start_date] = DateTime.now + 2
      poll[:end_date] = DateTime.now
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('start_date')
      expect(res['errors']['start_date']).to include("start date can't be farther than end date")
    end

    scenario 'start date has passed' do
      poll[:start_date] = DateTime.now - 2
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('start_date')
      expect(res['errors']['start_date']).to include('start date is in the past')
    end

    scenario 'missing end date field' do
      poll[:end_date] = nil
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('end_date')
      expect(res['errors']['end_date']).to include("can't be blank")
    end

    scenario 'invalid end date field' do
      poll[:end_date] = 'invalid date'
      visit_with_headers

      res = json
      expect(response).to have_http_status(422)
      expect(res['errors']).to include('end_date')
    end

    context 'Poll Questions' do
      scenario 'missing poll question fields' do
        poll.delete(:poll_questions_attributes)

        visit_with_headers

        res = json

        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_questions')
        expect(res['errors']['poll_questions']).to include("can't be blank")
      end

      scenario 'empty poll question fields' do
        poll[:poll_questions_attributes] = []

        visit_with_headers

        res = json

        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_questions')
        expect(res['errors']['poll_questions']).to include("can't be blank")
      end

      scenario 'missing poll question content field' do
        change_poll_question_content(poll, '')
        visit_with_headers

        res = json

        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_questions.content')
        expect(res['errors']['poll_questions.content']).to include("can't be blank")
      end

      scenario 'invalid poll question content field' do
        change_poll_question_content(poll, 'ab')
        visit_with_headers

        res = json

        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_questions.content')
        expect(res['errors']['poll_questions.content']).to include('is too short (minimum is 3 characters)')
      end
    end

    context 'Poll Answers' do
      scenario 'missing poll answer fields' do
        poll[:poll_questions_attributes][0][:poll_answers_attributes] = nil

        visit_with_headers

        res = json
        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_answers')
        expect(res['errors']['poll_answers']).to include("can't be blank")
      end

      scenario 'empty poll answer fields' do
        poll[:poll_questions_attributes][0][:poll_answers_attributes] = []

        visit_with_headers

        res = json

        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_answers')
        expect(res['errors']['poll_answers']).to include("can't be blank")
      end

      scenario 'missing poll answer content field' do
        change_poll_answer_content(poll, '')

        visit_with_headers

        res = json

        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_questions.poll_answers.content')
        expect(res['errors']['poll_questions.poll_answers.content']).to include("can't be blank")
      end

      scenario 'missing poll answer content field' do
        poll[:poll_questions_attributes][0][:poll_answers_attributes].pop

        visit_with_headers

        res = json

        expect(response).to have_http_status(422)
        expect(res['errors']).to include('poll_answers')
        expect(res['errors']['poll_answers']).to include('question should have at least 2 answers')
      end
    end

    scenario 'with valid attributes' do
      visit_with_headers

      res = json

      expect(response).to have_http_status(201)
      expect(res['host']['id']).to eq(user.id)
      expect(res['id']).to be_truthy
    end
  end

  context 'Get All User Polls' do
    user_token = nil
    poll = nil
    user = nil
    before do
      user = create :user
      poll = create :poll, host_id: user.id
      user_token = login_user(user)
    end

    let(:visit_with_headers) { get '/api/v1/polls', headers: headers(user_token) }
    let(:visit_without_headers) { get '/api/v1/polls' }

    scenario 'returns 401 if user is not logged in' do
      visit_without_headers
      res = json

      expect(response).to have_http_status(401)
      expect(response).not_to have_http_status(200)
      expect(res['errors']['message']).to eq('Kindly login or register')
    end

    scenario 'successfully returns polls of the logged in user' do
      visit_with_headers
      res = json

      expect(response).to have_http_status(200)
      expect(response).not_to have_http_status(401)
      expect(res).to be_an_instance_of(Array)
      res.each do |found_poll|

        expect(found_poll['host']['id']).to eq(user.id)
        expect(found_poll['host']['id']).not_to eq(1100)
      end
    end
  end

  context 'Get One User Poll' do
    user = nil
    user2 = nil
    user_token = nil
    user2_token = nil
    poll = nil
    before do
      user = create :user
      user2 = create :user, email: 'testmail@gmail.com'
      poll = create :poll, host_id: user.id
      user2_token = login_user(user2)
    end

    let(:visit_with_another_token) { get "/api/v1/polls/#{poll.id}", headers: headers(user2_token) }
    let(:visit_without_token) { get "/api/v1/polls/#{poll.id}" }

    scenario 'returns 401 if user is not logged in' do
      visit_without_token
      res = json

      expect(response).to have_http_status(401)
      expect(response).not_to have_http_status(200)
      expect(res['errors']['message']).to eq('Kindly login or register')
    end

    scenario 'returns 403 if user does not own the post' do
      visit_with_another_token
      res = json

      puts user_token
      puts user2_token

      expect(response).to have_http_status(403)
      expect(response).not_to have_http_status(200)
      expect(res['errors']['message']).to eq('You are not allowed to perform this operation')
    end

    scenario 'successfully returns the poll if accessed by owner' do
      delete '/api/v1/logout'
      user_token = login_user(user)
      get "/api/v1/polls/#{poll.id}", headers: headers(user_token)

      res = json

      expect(response).to have_http_status(200)
      expect(response).not_to have_http_status(401)
      expect(res).to be_an_instance_of(Hash)
      expect(res.keys).to include('id', 'title', 'info', 'start_date', 'end_date')
      expect(res['host']['id']).to eq(user.id)
    end
  end
end
