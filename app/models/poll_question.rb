class PollQuestion < ApplicationRecord
  belongs_to :poll
  has_many :poll_answers, dependent: :destroy
  has_one :answer, class_name: 'PollAnswer'

  accepts_nested_attributes_for :poll_answers

  validates_associated :poll_answers

  validates :content, presence: true, length: { minimum: 3 }
end
