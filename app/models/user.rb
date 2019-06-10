class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  validates_uniqueness_of    :email, :case_sensitive => false, unless: proc{ |user| user.email.blank? }
  validates_format_of        :email, :with  => Devise.email_regexp, unless: proc{ |user| user.email.blank? }

  validates_presence_of      :full_name

  validates_presence_of      :password, :on => :create
  validates_confirmation_of  :password, :on => :create
  validates_length_of        :password, :within => Devise.password_length, :allow_blank => true

  validates_presence_of      :system_generated_password, :on => :create
  validates_length_of        :system_generated_password, :within => Devise.password_length, :allow_blank => true

  validates_presence_of      :user_role
  validate :user_role_value_is_in_range

   # The available roles that can be assigned to the users of the system. 
  ROLES = ["Administrator", "Encoder", "Doctor"]

  # Returns true if role name string passed matches the user's role name
  #
  # @param role [String] the role name being compared against
  # @return [Boolean]
  def is_role?(role)
    return self.user_role == role rescue nil
  end

  # Adds an error message to the form to indicate that the user role input value is invalid
  #
  # @note the error string is 'invalid user role'
  def user_role_value_is_in_range
    unless User::ROLES.include?(self.user_role)
      errors.add(:user_role, 'invalid user role')
    end
  end

end