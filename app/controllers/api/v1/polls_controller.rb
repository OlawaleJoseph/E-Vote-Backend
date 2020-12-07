class Api::V1::PollsController < ApplicationController
  before_action :verify_token!
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_errors

  def create
    poll = current_user.polls.build(poll_params)
    messages = {}
    messages[:poll_questions] = ["can't be blank"] if poll.poll_questions.nil? || poll.poll_questions.empty?
    return display_error(422, messages) unless messages.keys.empty?

    poll.poll_questions.each do |record|
      if record.poll_answers.nil? || record.poll_answers.empty?
        messages[:poll_answers] = ["can't be blank"]
        return display_error(422, messages)
      end
    end

    poll.save!

    render json: poll, status: 201
  end

  private

  def handle_validation_errors(err)
    messages = {}
    err.record.errors.keys.each do |key|
      messages[key] = err.record.errors[key] unless messages[key]
    end
    render json: { errors: messages }, status: 422
  end

  def poll_params
    params.permit(
      :title,
      :info,
      :restricted,
      :start_date,
      :end_date,
      poll_questions_attributes:
        [:content, poll_answers_attributes: [:content]]
    )
  end
end
