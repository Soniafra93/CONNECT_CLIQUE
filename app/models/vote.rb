class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  validates :selected_date, presence: true
  validates :user_id, uniqueness: { scope: :activity_id, message: "You can only vote once per activity" }
end
