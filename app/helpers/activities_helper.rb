module ActivitiesHelper
  def user_voted_for_winning_date?(activity, date)
    return false unless activity.voting_closed? && activity.winning_date == date

    activity.votes.exists?(user: current_user, selected_date: date)
  end
end
