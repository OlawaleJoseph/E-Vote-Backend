class PollSerializer < ActiveModel::Serializer
  attributes :id, :title, :info, :img_url, :restricted, :start_date, :end_date, :host_id, :created_at

  belongs_to :host, class_name: 'User'
  has_many :poll_questions
end
