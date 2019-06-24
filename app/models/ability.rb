class Ability
  include CanCan::Ability

  # Assigns permissions to users of what actions/views can they access to the system.
  # @param user [Object] The user logged in to the system.
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_role? "Administrator"
      can [:read, :create, :update, :destroy], :all
      can [:reset_password], User

      cannot [:destroy], User do |user_object|
        user_object == user || user_object.is_last_admin? || !user_object.is_active?
      end

      can [:hmo_patients_index], Hmo
    end
  end
end
