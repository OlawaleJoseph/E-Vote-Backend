class PollQuestion < ApplicationRecord
  belongs_to :poll, dependent: :destroy

  validates :content, presence: true, length: { minimum: 3 }
end
