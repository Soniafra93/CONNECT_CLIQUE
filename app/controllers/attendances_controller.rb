class AttendancesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_activity, only: [:new, :create]
  before_action :set_attendance, only: [:show, :edit, :update, :destroy]

  def index
    @attendances = current_user.attendances.includes(:activity)
  end

  def new
    @attendance = Attendance.new
  end

  def create
    @attendance = current_user.attendances.new(attendance_params)
    if @attendance.save
      redirect_to @attendance.activity, notice: 'Attendance was successfully created.'
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @attendance.update(attendance_params)
      redirect_to @attendance.activity, notice: 'Attendance was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @attendance.destroy
    redirect_to attendances_url, notice: 'Attendance was successfully destroyed.'
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def set_attendance
    @attendance = Attendance.find(params[:id])
  end

  def attendance_params
    params.require(:attendance).permit(:activity_id, :selected_date)
  end
end
