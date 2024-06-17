class Friend < ApplicationRecord
  belongs_to :user
  belongs_to :attendee, class_name: "User", foreign_key: :attendee_id
end
