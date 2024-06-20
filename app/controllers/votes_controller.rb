class VotesController < ApplicationController
  before_action :set_activity
  before_action :authorize_vote, only: [:new, :create]

  def new
    @vote = Vote.new
  end

  def create
    @vote = Vote.new(vote_params)
    @vote.activity = @activity
    @vote.user = current_user
    if @vote.save
      redirect_to activity_path(@activity), notice: 'Your vote was successfully submitted.'
    else
      render :new, status: 422
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
