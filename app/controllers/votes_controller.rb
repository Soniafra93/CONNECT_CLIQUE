class VotesController < ApplicationController
  before_action :set_activity
  before_action :authorize_vote, only: [:create]

  def create
    # Remove the check for current user's votes
    @vote = Vote.new(vote_params)
    @vote.activity = @activity
    @vote.user = current_user
    if @vote.save
      render json: { message: 'Your vote was successfully submitted.' }, status: :ok
      Notification.create(
        user_id: @activity.user_id,
        message: "#{current_user.first_name} has voted for #{@activity.name}.",
        read: false
      )
    else
      render json: { message: @vote.errors.full_messages.join(', ') }, status: :unprocessable_entity
    end
  end

  def vote
    @activity = Activity.find(params[:id])
    if @activity.update(vote_params)
      # Notify the creator about the vote
      Notification.create(
        user_id: @activity.user_id,
        message: "#{current_user.name} has voted for #{@activity.name}.",
        read: false
      )
      redirect_to @activity, notice: 'Your vote was successfully submitted.'
    else
      redirect_to @activity, alert: 'There was an error submitting your vote.'
    end
  end

  private

  def set_activity
    @activity = Activity.find(params[:activity_id])
  end

  def vote_params
    params.require(:vote).permit(:selected_date)
  end

  def authorize_vote
    authorize Vote
  end
end
