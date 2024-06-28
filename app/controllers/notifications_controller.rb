class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = policy_scope(Notification).where(user: current_user).order(created_at: :desc)
  end

  def mark_as_read
    @notification = current_user.notifications.find(params[:id])
    if @notification.update(read: true)
      redirect_back(fallback_location: notifications_path)
    else
      flash[:alert] = "Failed to mark notification as read."
      redirect_back(fallback_location: notifications_path)
    end
  end
end
