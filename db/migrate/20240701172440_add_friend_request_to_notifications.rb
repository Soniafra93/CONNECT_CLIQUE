class AddFriendRequestToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :friend_request, :boolean
  end
end
