class NotificationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification, only: [:mark_as_read]

  def index
    @notifications = policy_scope(Notification).where(user: current_user).order(created_at: :desc)
  end

  def mark_as_read
    authorize @notification

    if @notification.update(read: true)
      respond_to do |format|
        format.html { redirect_back(fallback_location: notifications_path) }
        format.js
      end
    else
      flash[:alert] = "Failed to mark notification as read."
      redirect_back(fallback_location: notifications_path)
    end
  end

  private

  def set_notification
    @notification = current_user.notifications.find(params[:id])
  end
end
