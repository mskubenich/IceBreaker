class Ability
  include CanCan::Ability

  def initialize(user)
    # if user
    #   can :manage, User do |u|
    #     u.id == user.id
    #   end
    # else
    #   can :manage, User do |u|
    #     u.new_record?
    #   end
    #   can :create, User
    # end
    can :manage, :all
  end
end
