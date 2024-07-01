class VotesController < ApplicationController
  before_action :set_activity
  before_action :authorize_vote, only: [:create]

  def create
    @vote = Vote.new(vote_params)
    @vote.activity = @activity
    @vote.user = current_user

    # Parse the selected_date
    if params[:vote][:selected_date].present?
      begin
        @vote.selected_date = Date.parse(params[:vote][:selected_date])
      rescue Date::Error
        return render json: { message: 'Invalid date format' }, status: :unprocessable_entity
      end
    end

    if @vote.save
      respond_to do |format|
        format.json do
          render json: { message: 'Your vote was successfully submitted.' }, status: :ok
        end
        format.html do
          Notification.create(
            user_id: @activity.user_id,
            message: "#{current_user.first_name} has voted for #{@activity.name}.",
            read: false
          )
          redirect_to @activity, notice: 'Your vote was successfully submitted.'
        end
      end
    else
      respond_to do |format|
        format.json do
          render json: { message: @vote.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
        format.html do
          redirect_to @activity, alert: 'There was an error submitting your vote.'
        end
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
