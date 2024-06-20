class AddVotingClosedToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :voting_closed, :boolean
  end
end
