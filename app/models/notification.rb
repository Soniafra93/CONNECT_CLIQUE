class Notification < ApplicationRecord
  belongs_to :user

  def self.unread
    where(read: false)
  end

  def friend_request?
    sender_id.present?
  end
end
