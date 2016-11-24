class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if (user.admin? && !user.profesor?)
      can :manage, :all
      can :read, :all
      cannot :read, Dashboard
      can :me, User
      can :update_me, User
    elsif user.admin? && user.profesor?
      can :manage, :all
      can :read, :all
      can :me, User
      can :update_me, User
    elsif user.profesor?
      can :read, :all
      can :create, [Field,Feature]
      cannot :edit, [Field,Feature]
      cannot :destroy, [Field,Feature]
      can :manage, Workshop
      can :manage, Project
      can :me, User
      can :update_me, User
    else
      cannot :edit, :all
      can :read, [Dashboard,Project,:projects]
      can :me, User
      can :update_me, User
      can :update, Project
      
    end
  end
end
