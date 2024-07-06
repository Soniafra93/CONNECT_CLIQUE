class Notification < ApplicationRecord
  belongs_to :user

  validates :notification_type, inclusion: {in: %w(friend activity)}

  def self.unread
    where(read: false)
  end

  def friend_request?
    self.notification_type == "friend"
  end

  def activity_request?
    self.notification_type == "activity"
  end

end
