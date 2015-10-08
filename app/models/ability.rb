class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, User do |u|
        u.id == user.id
      end
    else
      can :create, User
    end
  end
end
