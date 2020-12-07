require 'rails_helper'

RSpec.describe Poll, type: :model do
  subject { build :poll }
  context '#Validations' do
    scenario { should validate_presence_of(:title) }
    scenario { should validate_length_of(:title).is_at_least(3) }
    scenario { should validate_length_of(:title).is_at_most(100) }

    scenario { should validate_presence_of(:info) }
    scenario { should validate_length_of(:info).is_at_least(3) }

    scenario { should validate_presence_of(:restricted) }

    scenario { should validate_presence_of(:img_url) }

    scenario { should validate_presence_of(:start_date) }
    scenario { should validate_presence_of(:end_date) }

    it 'start date should be less than end date' do
      invalid = subject
      invalid.start_date = DateTime.new(2090, 12, 31, 12, 12, 12)
      invalid.save
      expect(invalid.errors.messages.keys).to include(:start_date)
      expect(invalid.errors.messages[:start_date]).to include("start date can't be farther than end date")
    end

    it 'start date should be less than end date' do
      invalid = subject
      invalid.start_date = DateTime.new(2019, 12, 31, 12, 12, 12)
      invalid.save
      expect(invalid.errors.messages.keys).to include(:start_date)
      expect(invalid.errors.messages[:start_date]).to include('choose a future date for start date')
    end
  end

  context '#Assubject.valid?ociations' do
    scenario { should belong_to(:host) }
    scenario { should have_many(:poll_questions) }
    scenario { should have_many(:poll_answers) }
  end
end
