class Poll < ApplicationRecord
  belongs_to :host, class_name: 'User'

  validates :title, presence: true, length: { maximum: 100, minimum: 3 }
  validates :info, presence: true, length: { minimum: 3 }
  validates :restricted, presence: true
  validates :img_url, presence: true
  validates :start_date, presence: true
  validates :end_date, presence: true

  validate :check_date

  def check_date
    return if start_date.nil? || end_date.nil?

    puts start_date
    puts end_date
    puts
    if start_date > end_date
      errors.add(:start_date, "start date can't be farther than end date")
    elsif start_date < DateTime.now
      errors.add(:start_date, 'choose a future date for start date')
    end
  end

end
