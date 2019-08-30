class SurgeonsController < ApplicationController
  before_action :set_surgeon, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index, :archive, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active surgeon records.
  #   GET /surgeons
  #   GET /surgeons.json
  def index
    if current_user.is_role? "Doctor"
      @surgeons = Surgeon.where(doctor_id: current_user.id).order(:full_name).paginate(page: params[:page], per_page: 10)
    else
      @surgeons = Surgeon.order(:full_name).paginate(page: params[:page], per_page: 10)
    end
  end

  # Loads the details of a surgeon record.
  #   GET /surgeons/1
  #   GET /surgeons/1.json
  def show
  end

  # Loads the form for creating a new surgeon record.
  #   GET /surgeons/new
  def new
    @surgeon = Surgeon.new
  end

  # Loads the form for editing details of an existing surgeon record.
  #   GET /surgeons/1/edit
  def edit
  end

  # Creates a new surgeon record.
  #   POST /surgeons
  #   POST /surgeons.json
  def create
    @surgeon = Surgeon.new(surgeon_params)

    respond_to do |format|
      if @surgeon.save
        format.html { redirect_to surgeon_path(@surgeon, active_tab: TAB_NAMES[:system_settings]), notice: 'Surgeon was successfully created.' }
        format.json { render json: @surgeon.to_json, status: :created, location: @surgeon }
      else
        puts @surgeon.errors.first
        format.html { render :new }
        format.json { render json: @surgeon.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing surgeon record.
  #   PATCH/PUT /surgeons/1
  #   PATCH/PUT /surgeons/1.json
  def update
    respond_to do |format|
      if @surgeon.update(surgeon_params)
        format.html { redirect_to surgeon_path(@surgeon, active_tab: TAB_NAMES[:system_settings]), notice: 'Surgeon was updated' }
        format.json { render :show, status: :ok, location: @surgeon }
      else
        format.html { render :edit }
        format.json { render json: @surgeon.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes the record of a surgeon.
  #   DELETE /surgeons/1
  #   DELETE /surgeons/1.json
  def destroy
    if @surgeon.has_schedule?
      respond_to do |format|
        format.html { redirect_to surgeons_url, notice: 'Failed to destroy surgeon. Surgeon has schedule.' }
        format.json { head :no_content }
      end
    else
      @surgeon.destroy
      respond_to do |format|
        format.html { redirect_to surgeons_url, notice: 'Surgeon was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_surgeon
      @surgeon = Surgeon.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def surgeon_params
      params.require(:surgeon).permit(
        :full_name,
        :doctor_id
      )
    end
end
