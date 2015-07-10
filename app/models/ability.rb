class Ability
  include CanCan::Ability

  def initialize(user)

      user ||= User.new # guest user (not logged in)
      if user.role? :admin
        can :manage, :all
      elsif user.role? :employee
        can :read, :all
        can :update, User
        can :get_events, User
        can :manage, LeaveRequest
      end

  end
end
