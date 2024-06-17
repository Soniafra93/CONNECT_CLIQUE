class Activity < ApplicationRecord
  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates :name, presence: :true
  validates :description, presence: :true, length: { maximum: 500 }
  validates :address, presence: :true
  validates :date_1, presence: :true
  validates :date_2, presence: :true
  validates :date_3, presence: :true

  def most_voted_date
    dates = [date_1, date_2, date_3]
    tally = dates.map do |date|
      [date, votes.where(selected_date: date).count]
    end
    most_voted = tally.max_by { |date, count| count }
    most_voted ? most_voted[0] : nil
  end

end
