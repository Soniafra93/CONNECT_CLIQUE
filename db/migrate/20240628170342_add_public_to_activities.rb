class AddPublicToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :public, :boolean
  end
end
