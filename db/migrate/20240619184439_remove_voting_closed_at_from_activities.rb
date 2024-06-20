class RemoveVotingClosedAtFromActivities < ActiveRecord::Migration[7.1]
  def change
    remove_column :activities, :voting_closed_at, :datetime
  end
end
