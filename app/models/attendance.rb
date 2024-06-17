class Attendance < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  validates :user_id, uniqueness: { scope: :activity_id, message: "has already attended this activity" }
end
