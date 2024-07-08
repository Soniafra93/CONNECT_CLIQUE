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

    authorize(@activity)
    @vote = Vote.new
    @attendees = @activity.attendances.includes(:user)
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
    split_datetime_fields(@activity)

    authorize(@activity)

    if @activity.save
      if current_user.friends.present?
        current_user.friends.each do |friend|
          Notification.create!(
            user_id: friend.attendee.id,
            message: "You've been invited to vote for #{@activity.name}!",
            read: false,
            notification_type: "activity",
            type_id: @activity.id
          )
        end
      end
      redirect_to @activity, notice: 'Activity was successfully created.'
    else
      render :new
    end
  end

  def update
    authorize(@activity)
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
    authorize @activity, :close_voting?

    # Check if there's at least one vote
    if @activity.votes.empty?
      redirect_to @activity
      return
    end

    if @activity.update(voting_closed: true)
      winning_date = @activity.determine_winning_date

      if @activity.start_time.nil? || @activity.end_time.nil?
        @activity.update(start_time: Time.now, end_time: Time.now + 2.hours)
      end

      if winning_date
        # Include the activity creator and winning voters
        winning_voters = [@activity.user_id] + @activity.votes.where(selected_date: winning_date).pluck(:user_id)
        winning_voters.uniq.each do |user_id|
          Attendance.create(
            user_id: user_id,
            activity: @activity,
            start_time: @activity.start_time,
            end_time: @activity.end_time
          )
        end

        # Notify all voters about the result
        all_voters = @activity.votes.pluck(:user_id).uniq
        all_voters.each do |user_id|
          Notification.create(
            user_id: user_id,
            message: "Voting for #{@activity.name} has closed. The winning date is #{winning_date}.",
            read: false
          )
        end
      end
    end

    redirect_to @activity
  end

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :date_1, :date_2, :date_3, :start_time, :end_time, :user_id, :members, photos: [], friend_ids: [])
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
