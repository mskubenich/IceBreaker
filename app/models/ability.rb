class Ability
  include CanCan::Ability

  def initialize(user)
    if user
      can :manage, User do |u|
        u.id == user.id
      end

      can :manage, Conversation do |conversation|
        [conversation.initiator_id, conversation.opponent_id].include?(user.id) || conversation.new_record?
      end
    else
      can :manage, User do |u|
        u.new_record?
      end
      can :create, User
    end
  end
end
