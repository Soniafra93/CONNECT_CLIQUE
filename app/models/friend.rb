class Friend < ApplicationRecord
  belongs_to :user
  has_many :friends_as_user, class_name: "Friends", foreign_key: :user_id
  has_many :friends_as_attendee, class_name: "Friends", foreign_key: :attendee_id
end
