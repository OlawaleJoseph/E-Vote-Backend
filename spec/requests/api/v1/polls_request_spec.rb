require 'rails_helper'

RSpec.describe 'Api::V1::Polls', type: :request do
  user = nil
  poll = nil
  token = nil
  context 'Polls Creation' do
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

        p poll

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
      expect(res['host_id']).to eq(user.id)
      expect(res['id']).to be_truthy
    end
  end
end
