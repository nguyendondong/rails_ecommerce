class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, Product

    return unless user.present?
    can [:read, :create, :update], Order, user: user

    return unless user.admin?
    can :manage, :all
  end
end
