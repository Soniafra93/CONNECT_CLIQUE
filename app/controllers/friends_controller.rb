class FriendsController < ApplicationController
  before_action :authenticate_user!

  def index
    @friends = current_user.friends
    @friends = policy_scope(Friend)
    @users = User.all.where.not(id: current_user.id)
  end

  def create
    @attendee = User.find(params[:attendee_id])

    authorize(Friend)

    if @attendee
      if current_user.friends.exists?(attendee_id: @attendee.id)
        redirect_to friends_path, notice: "Friend already added."
      else
        current_user.friends.create(attendee_id: @attendee.id)
        redirect_to friends_path, notice: "Friend added successfully."
      end
    else
      redirect_to friends_path, alert: "Unable to find friend with that name."
    end
  end

  def destroy
    friend = current_user.friends.find_by(id: params[:id])

    if friend
      authorize(friend)
      friend.destroy
      redirect_to friends_path, notice: "Friend removed successfully."
    else
      redirect_to friends_path, alert: "Unable to remove friend."
    end
  end
end
