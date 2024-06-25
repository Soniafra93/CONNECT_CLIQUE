class ActivityPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5
  def show?
    return true
  end

  def new?
    return create?
  end

  def create?
    return true
  end

  def edit?
    return update?
  end

  def update?
    return record.user == user
  end

  def destroy?
    return record.user == user
  end

  def close_voting?
    record.user == user && !record.voting_closed?
  end


  class Scope < Scope
    # NOTE: Be explicit about which records you allow access to!
    def resolve
      if record.members == "friends"
        raise
        if user.mine_and_friend_user_ids.present?
          scope.where( user: user.mine_and_friend_user_ids)
        else
          scope.where( user: user)
        end
      else
        scope.all
      end
    end
  end
end
