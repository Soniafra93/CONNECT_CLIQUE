class AddTypeAndTypeIdToNotifications < ActiveRecord::Migration[7.1]
  def change
    add_column :notifications, :notification_type, :string
    add_column :notifications, :type_id, :string
  end
end
