class ActivitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:show, :edit, :update, :destroy]

  def index
    @activities = policy_scope(Activity)
  end

  def show
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

  private

  def set_activity
    @activity = Activity.find(params[:id])
  end

  def activity_params
    params.require(:activity).permit(:name, :description, :address, :date_1, :date_2, :date_3, :start_time, :end_time, :user_id)
  end
end
