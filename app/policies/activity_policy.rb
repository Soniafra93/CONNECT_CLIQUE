class ActivityPolicy < ApplicationPolicy
  def show?
    record.visible_to?(user)
  end

  def new?
    create?
  end

  def create?
    true
  end

  def edit?
    update?
  end

  def update?
    record.user == user
  end

  def destroy?
    record.user == user
  end

  def close_voting?
    record.user == user && !record.voting_closed?
  end

  class Scope < Scope
    def resolve
      if user.mine_and_friend_user_ids.present?
        scope.left_joins(:attendances)
             .where("activities.members = ? OR activities.user_id IN (?) OR attendances.user_id = ?",
                    "public",
                    user.mine_and_friend_user_ids,
                    user.id)
             .distinct
      else
        scope.left_joins(:attendances)
             .where("activities.members = ? OR activities.user_id = ? OR attendances.user_id = ?",
                    "public",
                    user.id,
                    user.id)
             .distinct
      end
    end
  end
end
