class VotePolicy < ApplicationPolicy
  def new?
    user.present?
  end

  def create?
    true # Allow any user to create a vote
  end
end
