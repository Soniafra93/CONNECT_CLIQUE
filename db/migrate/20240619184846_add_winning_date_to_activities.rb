class AddWinningDateToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :winning_date, :date
  end
end
