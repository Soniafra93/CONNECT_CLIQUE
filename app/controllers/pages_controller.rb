class PagesController < ApplicationController
  def home
    # Scope your query to the dates being shown:
    start_date = params.fetch(:start_date, Date.today).to_date

    # For a monthly view:
    @meetings = Activity.where(date_1: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end

  def index
    # Scope your query to the dates being shown:
    start_date = params.fetch(:start_date, Date.today).to_date

    # For a monthly view:
    @meetings = Activity.where(date_1: start_date.beginning_of_month.beginning_of_week..start_date.end_of_month.end_of_week)
  end
end
