class Poll < ApplicationRecord
  belongs_to :host, class_name: 'User'
  has_many :poll_questions, dependent: :destroy
  accepts_nested_attributes_for :poll_questions

  validates_associated :poll_questions

  validates :title, presence: true, length: { maximum: 100, minimum: 3 }
  validates :info, presence: true, length: { minimum: 3 }
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :check_date

  private

  def check_date
    return if start_date.nil? || end_date.nil?

    if start_date > end_date
      errors.add(:start_date, "start date can't be farther than end date")
    elsif start_date == end_date
      errors.add(:start_date, "start date can't be equal to end date")
    elsif start_date < DateTime.now
      errors.add(:start_date, 'start date is in the past')
    end
  end
end
