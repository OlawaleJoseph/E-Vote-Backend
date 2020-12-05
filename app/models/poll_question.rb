class PollQuestion < ApplicationRecord
  belongs_to :poll, dependent: :destroy
  has_many :poll_answers

  validates :content, presence: true, length: { minimum: 3 }
end
