class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if (user.admin? && !user.profesor?)
      can :manage, :all
      cannot :read, Dashboard
    elsif user.admin? && user.profesor?
      can :manage, :all
    elsif user.profesor?
      can :read, :all
      can :manage, Workshop
      can :manage, Project
    else
      can :read, :all
      can :me, User
      can :update_me, User
      can :update, Project
    end
  end
end
