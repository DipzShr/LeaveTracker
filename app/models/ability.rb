class Ability
  include CanCan::Ability

  def initialize(user)
      user ||= User.new # guest user (not logged in)
      if user.role? :admin
        can :manage, :all
      elsif user.role? :employee
        can :read, :all
        can :get_events, User
        can :create, LeaveRequest
      end

  end
end
