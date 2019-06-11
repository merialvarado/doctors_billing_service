class PatientsController < ApplicationController
	before_action :set_patient, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index, :archive, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active patient records.
  #   GET /patients
  #   GET /patients.json
  def index
    @patients = Patient.all
  end

  # Loads the details of a patient record.
  #   GET /patients/1
  #   GET /patients/1.json
  def show
  end

  # Loads the form for creating a new patient record.
  #   GET /patients/new
  def new
    @patient = Patient.new
  end

  # Loads the form for editing details of an existing patient record.
  #   GET /patients/1/edit
  def edit
  end

  # Creates a new patient record.
  #   POST /patients
  #   POST /patients.json
  def create
    @patient = Patient.new(patient_params)

    respond_to do |format|
      if @patient.save
        format.html { redirect_to @patient, notice: 'Patient was successfully created.' }
        format.json { render :show, status: :created, location: @patient }
      else
        format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing patient record.
  #   PATCH/PUT /patients/1
  #   PATCH/PUT /patients/1.json
  def update
    respond_to do |format|
      if @patient.update(patient_params)
        format.html { redirect_to @patient, notice: 'Patient was updated' }
        format.json { render :show, status: :ok, location: @patient }
      else
        format.html { render :edit }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes the record of a patient.
  #   DELETE /patients/1
  #   DELETE /patients/1.json
  def destroy
    if @patient.has_schedule?
      respond_to do |format|
        format.html { redirect_to patients_url, notice: 'Failed to destroy patient. Patient has schedule.' }
        format.json { head :no_content }
      end
    else
      @patient.destroy
      respond_to do |format|
        format.html { redirect_to patients_url, notice: 'Patient was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient
      @patient = Patient.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_params
      params.require(:patient).permit(
        :first_name,
        :middle_name, 
        :surname,
        :patient_num,
        :date_admitted,
        :procedure,
        :hmo,
        :contact_num,
        :hospital_id,
        :doctor_id
      )
    end
end
