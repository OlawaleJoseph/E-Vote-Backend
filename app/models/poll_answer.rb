class PollAnswer < ApplicationRecord
  belongs_to :poll_question, dependent: :destroy

  validates :content, presence: true
end
