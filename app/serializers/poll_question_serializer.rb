class PollQuestionSerializer < ActiveModel::Serializer
  attributes :id, :content

  has_many :poll_answers
  belongs_to :poll
end
