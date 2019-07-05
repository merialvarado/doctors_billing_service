class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :get_username, :reset_password]
  load_and_authorize_resource only: [:index, :archive, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active user records.
  #   GET /users
  #   GET /users.json
  def index
    @users = User.all.paginate(page: params[:page], per_page: 10)
  end

  # Loads the details of a user record.
  #   GET /users/1
  #   GET /users/1.json
  def show
    @user = User.find(params[:id])
  end

  # Loads the form for creating a new user record.
  #   GET /users/new
  def new
    @user = User.new
  end

  # Loads the form for editing details of an existing user record.
  #   GET /users/1/edit
  def edit
  end

  # Creates a new user record.
  #   POST /users
  #   POST /users.json
  def create
    @user = User.new(user_params)

    generated_password = Devise.friendly_token.first(8)    
    @user.system_generated_password = generated_password
    @user.password = generated_password

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing user record.
  #   PATCH/PUT /users/1
  #   PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was updated' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes the record of a user.
  #   DELETE /users/1
  #   DELETE /users/1.json
  def destroy
    if @user.has_schedule?
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'Failed to destroy user. User has schedule.' }
        format.json { head :no_content }
      end
    else
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  def dashboard
    @user = current_user
  end

  # Deactivate an active user record.
  #   DEACTIVATE /users/:id/deactivate
  def deactivate
    @user = User.find(params[:id])
    @user.deactivate
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully deactivated.' }
      format.json { head :no_content }
    end
  end

  # Activate an inactive user record.
  #   ACTIVATE /users/:id/activate
  def activate
    @user = User.find(params[:id])
    @user.activate
    respond_to do |format|
      format.html { redirect_to archive_users_url, notice: 'User was successfully activated.' }
      format.json { head :no_content }
    end
  end

  # Deactivate multiple active user records.
  #   BATCH_DEACTIVATE /users/batch_deactivate/user_id=1
  #   BATCH_DEACTIVATE /users/{flag: boolean}.json
  #
  # @note Sends ids of users lined up for deactivation and returns true after users are deactivated
  def batch_deactivate
    User.batch_deactivate(params[:user_ids])
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'Selected users were successfully deactivated.' }
      format.json { head :no_content }
    end
  end

  # Activate multiple inactive user records.
  #   BATCH_ACTIVATE /users/batch_activate/user_id=1
  #   BATCH_ACTIVATE /users/{flag: boolean}.json
  #
  # @note Sends ids of users lined up for activation and returns true after users are activated
  def batch_activate
    User.batch_activate(params[:user_ids])
    respond_to do |format|
      format.html { redirect_to archive_users_url, notice: 'Selected users were successfully activated.' }
      format.json { head :no_content }
    end
  end

  # # Loads a list of all inactive user records.
  # #   GET /users/archive
  # def archive
  #   @users = User.all_inactive
  # end

  # Loads a form view where the current user can change his/her password
  #   GET /users/:id/edit_password
  def edit_password
    @user = current_user
  end

  # Updates the current user's password based on the parameters given from edit_password
  #   GET /users/:id/update_password
  def update_password
    @user = User.find(current_user.id)
    respond_to do |format|
      if @user.update_with_password(user_params)
        sign_in @user, :bypass => true
        format.html { redirect_to @user, notice: 'Your password has been changed successfully.' }
        format.json { head :no_content }
      else
        format.html { render :edit_password }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # Resets a user's password
  #   GET /users/:id/reset_password
  def reset_password
    generated_password = Devise.friendly_token.first(8)    
    @user.system_generated_password = generated_password
    @user.password = generated_password

    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: "Password reset for #{@user.full_name} successful." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { redirect_to @user, notice: "Password reset failed." }
        format.json { render :show, status: :created, location: @user }
      end
    end
  end

  def system_settings
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(
        :user_role,
        :full_name, 
        :email, 
        :password, 
        :password_confirmation,
        :current_password,
        :hospital_id
      )
    end
end
