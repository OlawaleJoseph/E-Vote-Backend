class PollAnswer < ApplicationRecord
  belongs_to :poll, dependent: :destroy
  belongs_to :poll_question, dependent: :destroy
  belongs_to :question, class_name: 'PollQuestion', optional: true

  validates :content, presence: true
end
