class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  validates :start_time, :end_time, presence: true
  validates :user_id, uniqueness: { scope: :activity_id, message: "has already attended this activity" }

  default_scope -> { order(:start_time) }  # Our meetings will be ordered by their start_time by default

  def time
    "#{start_time.strftime('%I:%M %p')} - #{end_time.strftime('%I:%M %p')}"
  end

  def multi_days?
    (end_time.to_date - start_time.to_date).to_i >= 1
  end
end
