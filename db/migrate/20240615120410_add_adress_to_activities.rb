class AddAdressToActivities < ActiveRecord::Migration[7.1]
  def change
    add_column :activities, :address, :string
  end
end
