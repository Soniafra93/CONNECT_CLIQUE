module ApplicationHelper
  def sorted_events
    @sorted_events ||= @activities.group_by(&:winning_date)
  end
end
