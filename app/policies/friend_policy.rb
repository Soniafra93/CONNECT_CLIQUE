class FriendPolicy < ApplicationPolicy
  def show?
    record.user == user || record.attendee == user
  end

  def create?
    true
  end

  def new_friend?
    true
  end

  def destroy?
    record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user).or(scope.where(attendee: user))
    end
  end
end
