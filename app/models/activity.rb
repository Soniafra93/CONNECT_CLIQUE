class Activity < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many_attached :photos

  validates :name, :description, :address, :date_1, :date_2, :date_3, presence: true
  validates :members, inclusion: { in: %w(friends public) }

  def determine_winning_date
    dates = [date_1, date_2, date_3].uniq.compact  # Ensure dates are distinct and remove nil values
    vote_counts = dates.map { |date| votes.where(selected_date: date).count }

    max_votes = vote_counts.max
    winning_dates = dates.select.with_index { |_, i| vote_counts[i] == max_votes }

    if winning_dates.size == 1
      self.update(winning_date: winning_dates.first)

      # Add activity instances to the calendars of users who voted for the winning date
      votes.where(selected_date: winning_dates.first).each do |vote|
        Attendance.create(user: vote.user, activity: self, start_time: start_time, end_time: end_time)
      end
    else
      # Handle tie case (if needed)
      # For now, just update with the first winning date found
      self.update(winning_date: winning_dates.first)
    end
  end

  def most_voted_date
    dates = [date_1, date_2, date_3]
    tally = dates.map do |date|
      [date, votes.where(selected_date: date).count]
    end
    tally.max_by { |_, count| count }&.first
  end
end
