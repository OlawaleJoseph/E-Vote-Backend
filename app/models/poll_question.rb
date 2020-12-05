class PollQuestion < ApplicationRecord
  belongs_to :poll, dependent: :destroy
  has_many :poll_answers
  has_one :answer, class_name: 'PollAnswer'

  validates :content, presence: true, length: { minimum: 3 }
end
