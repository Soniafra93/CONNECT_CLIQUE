class RenameLatituteToLatitudeInActivities < ActiveRecord::Migration[6.1]
  def change
    rename_column :activities, :latitute, :latitude
  end
end
