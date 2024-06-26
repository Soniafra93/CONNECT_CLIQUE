class Notification < ApplicationRecord
  belongs_to :user

  def self.unread
    where(read: false)
  end
end
