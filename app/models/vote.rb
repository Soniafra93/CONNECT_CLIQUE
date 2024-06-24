class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :activity
  validates :selected_date, presence: true
end
