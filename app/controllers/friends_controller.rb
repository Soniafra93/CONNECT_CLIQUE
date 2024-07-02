class FriendsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_users, only: [:index, :create]
  after_action :verify_authorized, except: [:index]
  after_action :verify_policy_scoped, only: [:index]

  def index
    @friends = policy_scope(Friend).includes(:attendee).where(user: current_user)
  end

  def create
    @attendee = User.find_by(id: params[:friend][:attendee_id])
    if @attendee && @attendee != current_user && !current_user.friends.exists?(attendee_id: @attendee.id)
      friend = current_user.friends.new(attendee_id: @attendee.id)
      authorize friend
      if friend.save
        redirect_to friends_path, notice: "Friend added successfully."
      else
        redirect_to friends_path, alert: "Unable to add friend."
      end
    else
      authorize current_user.friends.new
      redirect_to friends_path, alert: "Unable to add friend."
    end
  end

  def destroy
    @friend = current_user.friends.find_by(id: params[:id])
    authorize @friend
    if @friend
      @friend.destroy
      redirect_to friends_path, notice: "Friend removed successfully."
    else
      redirect_to friends_path, alert: "Unable to remove friend."
    end
  end

  private

  def set_users
    friend_ids = current_user.friends.pluck(:attendee_id)
    @users = User.where.not(id: current_user.id).where.not(id: friend_ids)
  end
end

