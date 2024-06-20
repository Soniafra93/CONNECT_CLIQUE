class PagesController < ApplicationController
  before_action :set_calendar_events, only: [:home]

  def home
    @sorted_events = Activity.where(voting_closed: true).group_by(&:winning_date)
    @activities = Activity.where(voting_closed: true) # Add this line to set @activities
  end

  def index
    start_date = params.fetch(:start_date, Date.today).to_date
    @activities = Activity.where(start_time: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  private

  def set_calendar_events
    @sorted_events = Activity.where(voting_closed: true).group_by(&:winning_date)
  end
end
