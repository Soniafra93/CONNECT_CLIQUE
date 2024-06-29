class PagesController < ApplicationController
  before_action :set_calendar_events, only: [:home]

  def home
    @activities = policy_scope(Activity)
                    .joins(:attendances)
                    .where(attendances: { user_id: current_user.id }, voting_closed: true)
                    .distinct
    @sorted_events = @activities.group_by(&:winning_date)
  end

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @activities = policy_scope(Activity)
                    .joins(:attendances)
                    .where(attendances: { user_id: current_user.id })
                    .where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
                    .distinct
  end

  private

  def set_calendar_events
    @activities = policy_scope(Activity)
                    .joins(:attendances)
                    .where(attendances: { user_id: current_user.id }, voting_closed: true)
                    .distinct
    @sorted_events = @activities.group_by(&:winning_date)
  end
end
