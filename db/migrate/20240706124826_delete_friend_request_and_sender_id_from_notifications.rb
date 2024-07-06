class DeleteFriendRequestAndSenderIdFromNotifications < ActiveRecord::Migration[7.1]
  def change
    remove_column :notifications, :sender_id, foreign_key: { to_table: :users }
    remove_column :notifications, :friend_request, :boolean
  end
end
