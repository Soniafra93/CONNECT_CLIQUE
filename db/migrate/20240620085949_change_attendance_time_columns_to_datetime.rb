class ChangeAttendanceTimeColumnsToDatetime < ActiveRecord::Migration[7.1]
  def up
    change_column :attendances, :start_time, :datetime, using: "to_timestamp(to_char(start_time, 'HH24:MI:SS'), 'HH24:MI:SS')"
    change_column :attendances, :end_time, :datetime, using: "to_timestamp(to_char(end_time, 'HH24:MI:SS'), 'HH24:MI:SS')"
  end

  def down
    change_column :attendances, :start_time, :time
    change_column :attendances, :end_time, :time
  end
end
