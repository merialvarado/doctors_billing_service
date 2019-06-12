class PatientsController < ApplicationController
	before_action :set_patient, only: [:show, :edit, :update, :destroy, :check_available, :make_payment]
  load_and_authorize_resource only: [:index, :archive, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active patient records.
  #   GET /patients
  #   GET /patients.json
  def index
    @patients = Patient
    if params[:search_patients].nil?
      @patients = @patients.all
    else
      if !(from_date = params[:search_patients][:from_date]).blank?
        @patients = @patients.where("date_admitted >= ?", from_date )
      end
      if !(to_date = params[:search_patients][:to_date]).blank?
        @patients = @patients.where("date_admitted <= ?", to_date )
      end

      if (from_date = params[:search_patients][:from_date]).blank? && (to_date = params[:search_patients][:to_date]).blank?
        @patients = @patients.all
      end
    end
    @patients = @patients.paginate(page: params[:page], per_page: 10)
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
    @patient.payment_status = "CHECK WAITING"
    @patient.balance = @patient.billing_amount

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
        # TODO: Update the balance field based on the billing amount less payments
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

  def check_available
    @patient.check_available!

    respond_to do |format|
      format.html { redirect_to patients_url, notice: "Check is AVAILABLE in the hospital #{@patient.hospital.name rescue nil} for Patient: #{@patient.full_name}" }
      format.json { head :no_content }
    end 
  end

  def make_payment
    @payment = @patient.payments.build
  end

  def pay
    payment = Payment.new(payment_params)
    @patient = payment.patient

    respond_to do |format|
      if payment.save
        @patient.update_attribute(:balance, @patient.balance - payment.amount )
        @patient.update_payment_status

        format.html { redirect_to patient_path(payment.patient), notice: 'Payment was successfully created.' }
        format.json { render :show, status: :created, location: @patient }
      else
        @payment = @patient.payments.build
        format.html { render :make_payment }
        format.json { render json: payment.errors, status: :unprocessable_entity }
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
        :doctor_id,
        :billing_amount
      )
    end

    def payment_params
      params.require(:payment).permit(
       :check_num,
       :check_date,
       :bank,
       :patient_id,
       :amount
      )
    end
end
