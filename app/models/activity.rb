class Activity < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user
  has_many :attendances, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many_attached :photos

  validates :name, :description, :address, :date_1, :date_2, :date_3, presence: true
  validates :members, inclusion: { in: %w(friends public) }

  scope :public_activities, -> { where(members: 'public') }
  scope :friends_activities, ->(user) { where(members: 'friends', user: user.friends.pluck(:attendee_id)) }

  def determine_winning_date
    dates = [date_1, date_2, date_3].uniq.compact
    vote_counts = dates.map { |date| votes.where(selected_date: date).count }

    max_votes = vote_counts.max
    winning_dates = dates.select.with_index { |_, i| vote_counts[i] == max_votes }

    if winning_dates.any?
      winning_date = winning_dates.first
      self.update(winning_date: winning_date)
      winning_date
    else
      nil
    end
  end

  def winning_date
    return nil unless voting_closed?
    most_voted_date
  end

  def user_has_voted?(user)
    votes.exists?(user: user)
  end

  def most_voted_date
    dates = [date_1, date_2, date_3]
    tally = dates.map do |date|
      [date, votes.where(selected_date: date).count]
    end
    tally.max_by { |_, count| count }&.first
  end

  def visible_to?(user)
    members == 'public' ||
    user == self.user ||
    user.friend_of?(self.user) ||
    user.attendances.exists?(activity: self)
  end
end
