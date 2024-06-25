class VotesController < ApplicationController
  before_action :set_activity
  before_action :authorize_vote, only: [:create]

  def create
    if current_user.votes.exists?(activity: @activity)
      render json: { success: false, errors: ['You have already voted for this activity'] }, status: :unprocessable_entity
    else
      @vote = Vote.new(vote_params)
      @vote.activity = @activity
      @vote.user = current_user
      if @vote.save
        render json: { success: true, message: 'Your vote was successfully submitted.' }
      else
        render json: { success: false, errors: @vote.errors.full_messages }, status: :unprocessable_entity
      end
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
