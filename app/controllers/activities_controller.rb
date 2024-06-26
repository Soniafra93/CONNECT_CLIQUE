class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy, :close_voting]

  def index
    @activities = policy_scope(Activity)
    if params[:query].present?
      @activities = @activities.where("name ILIKE ?", "%#{params[:query]}%")
    end

    if @activities.empty? && params[:query].present?
      flash.now[:alert] = "No activities found under the name '#{params[:query]}'"
    end
  end

  def show
    @markers = [{
      lat: @activity.latitude,
      lng: @activity.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: { activity: @activity })
    }]

    @vote = Vote.new
    @attendees = @activity.attendances.includes(:user)
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
    @activity = Activity.new(activity_params)
    @activity.user = current_user
    # Split datetime strings into separate date and time attributes
    split_datetime_fields(@activity)

    authorize(@activity)

    if @activity.save
      if params[:activity][:friend_ids].present?
        params[:activity][:friend_ids].each do |friend_id|
          @activity.attendances.create(user_id: friend_id)
        end
      end
      redirect_to @activity, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize(@activity)

    # Split datetime strings into separate date and time attributes
    split_datetime_fields(@activity)

    if @activity.update(activity_params)
      redirect_to @activity, notice: 'Activity was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    authorize @activity

    if @activity.destroy
      redirect_to activities_path, notice: 'Activity was successfully deleted.'
    else
      redirect_to @activity, alert: 'Failed to delete activity.'
    end
  end

  def close_voting
    @activity = Activity.find(params[:id])
    authorize @activity, :close_voting?

    @activity.update(voting_closed: true)
    @activity.determine_winning_date

    # Set start_time and end_time if they are not already set
    if @activity.start_time.nil? || @activity.end_time.nil?
      @activity.update(start_time: Time.now, end_time: Time.now + 2.hours) # Example setting start and end times
    end

    # Redirect back to the activity show page
    redirect_to @activity, notice: 'Voting has been closed.'
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :date_1, :date_2, :date_3, :start_time, :end_time, :user_id, photos: [], friend_ids: [], members: ["public", "friends"] )
  end

  def split_datetime_fields(activity)
    activity.date_1, activity.time_1 = split_datetime(params[:activity][:date_1])
    activity.date_2, activity.time_2 = split_datetime(params[:activity][:date_2])
    activity.date_3, activity.time_3 = split_datetime(params[:activity][:date_3])
  end

  def split_datetime(datetime_string)
    return if datetime_string.blank?

    datetime = DateTime.parse(datetime_string)
    [datetime.to_date, datetime.to_time]
  end
end
