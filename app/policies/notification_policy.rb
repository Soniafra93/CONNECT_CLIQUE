class NotificationPolicy < ApplicationPolicy
  def mark_as_read?
    user.present? && record.user == user
  end

  class Scope < Scope
    def resolve
      scope.where(user: user)
    end
  end
end
