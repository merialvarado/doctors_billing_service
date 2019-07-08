class Ability
  include CanCan::Ability

  # Assigns permissions to users of what actions/views can they access to the system.
  # @param user [Object] The user logged in to the system.
  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.is_role? "Administrator"
      can [:manage], :all
      can [:read, :create, :update, :destroy], :all
      can [:reset_password], User

      cannot [:destroy], User do |user_object|
        user_object == user || user_object.is_last_admin? || !user_object.is_active?
      end

      can [:hmo_patients_index], Hmo

      cannot [:edit, :destroy, :process_csv], PatientUpload do |pu|
        pu.state == "processed"
      end
    end

    if user.is_role? "Doctor"
      can [:show], User do |user_object|
        user_object == user
      end
      can [:create, :update, :destroy, :uploaded_patients_index, :read, :download_image], Patient
      can [:hmo_patients_index], Hmo
    end

    if user.is_role? "Encoder"
      can [:show], User do |user_object|
        user_object == user
      end
      can [:update, :make_payment, :check_available, :uploaded_patients_index, :read, :download_image], Patient
      can [:hmo_patients_index], Hmo

      can [:manage], Hmo
      can [:manage], Hospital

      can [:manage], PatientUpload
      cannot [:edit, :destroy, :process_csv], PatientUpload do |pu|
        pu.state == "processed"
      end
    end
  end
end
