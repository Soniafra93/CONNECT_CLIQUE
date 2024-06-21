class AddTimesToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :time_1, :time
    add_column :activities, :time_2, :time
    add_column :activities, :time_3, :time
  end
end
