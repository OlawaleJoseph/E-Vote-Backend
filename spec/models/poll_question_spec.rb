require 'rails_helper'

RSpec.describe PollQuestion, type: :model do
  subject { build :poll_question }

  context 'Validations' do
    scenario { should validate_presence_of(:content) }
    scenario { should validate_length_of(:content).is_at_least(3) }
  end

  context 'Associations' do
    scenario { should belong_to(:poll) }
  end
end
