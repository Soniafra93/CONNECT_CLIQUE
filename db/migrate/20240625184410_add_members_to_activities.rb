class AddMembersToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :members, :string
  end
end
