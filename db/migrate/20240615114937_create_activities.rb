class CreateActivities < ActiveRecord::Migration[7.1]
  def change
    create_table :activities do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.text :description
      t.date :date_1
      t.date :date_2
      t.date :date_3
      t.date :most_voted_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
