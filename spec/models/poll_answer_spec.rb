require 'rails_helper'

RSpec.describe PollAnswer, type: :model do
  subject { build :poll_answer }

  context 'Validations' do
    scenario { should validate_presence_of(:content) }
  end

  context 'Associations' do
    scenario { should belong_to(:poll) }
    scenario { should belong_to(:poll_question) }
    scenario { should belong_to(:question).optional }
  end
end
