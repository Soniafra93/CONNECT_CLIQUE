class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :close_voting]

  def index
    @activities = policy_scope(Activity)
  end

  def show
    @markers = [{
      lat: @activity.latitude,
      lng: @activity.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: { activity: @activity })
    }]

    authorize(@activity)
  end

  def new
    @activity = Activity.new
    authorize(@activity)
  end

  def edit
    authorize(@activity)
  end

  def create
    @activity = current_user.activities.build(activity_params)
    @activity.user = current_user

    authorize(@activity)

    if @activity.save
      redirect_to @activity, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize(@activity)

    if @activity.update(activity_params)
      redirect_to @activity, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize(@activity)

    @activity.destroy
    redirect_to activities_url, status: :see_other, notice: 'Activity was successfully destroyed.'
  end

  def close_voting
    @activity = Activity.find(params[:id])
    authorize @activity, :close_voting?

    @activity.update(voting_closed: true)
    @activity.determine_winning_date

    # Set start_time and end_time if they are not already set
    if @activity.start_time.nil? || @activity.end_time.nil?
      @activity.update(start_time: Time.now, end_time: Time.now + 2.hours)  # Example setting start and end times
    end

    # Redirect back to the activity show page
    redirect_to @activity, notice: 'Voting has been closed.'
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :date_1, :date_2, :date_3, :start_time, :end_time, :user_id)
  end
end
