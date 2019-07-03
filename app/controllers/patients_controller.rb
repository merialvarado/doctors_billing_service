class PatientsController < ApplicationController
	before_action :set_patient, only: [:show, :edit, :update, :destroy, :check_available, :make_payment]
  load_and_authorize_resource only: [:index, :archive, :show, :new, :create, :edit, :update, :destroy, :uploaded_patients_index]

  # Loads a list of all active patient records.
  #   GET /patients
  #   GET /patients.json
  def index
    @patients = Patient.where("state IS NULL or state != 'picture_uploaded'")

    if current_user.is_role?("Doctor")
      @patients = @patients.where(doctor_id: current_user.id)
    end

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
    @patients = @patients.order("created_at desc").paginate(page: params[:page], per_page: 10)
  end

  def uploaded_patients_index
    @patients = Patient.where(state: "picture_uploaded")

    @patients = @patients.paginate(page: params[:page], per_page: 10)
  end

  def payment_method_patients_index
    hmo_id = params[:hmo_id]
    doctor_id = params[:doctor_id]
    hospital_ids = params[:hospital_ids]
    date = params[:date]
    @payment_method = ""
    @patients = []
    @active_tab = params[:active_tab]

    unless hmo_id.blank?
      @hmo = Hmo.find(hmo_id)
      @payment_method = "INSURANCE COMPANIES"
      unless doctor_id.blank?
        @patients = Patient.where("doctor_id = ? AND hmo_id = ? AND hospital_id IN (?) AND payment_status != ? AND date_admitted <= ?", doctor_id, hmo_id, hospital_ids, Patient::PAYMENT_STATUS[:fully_paid], date)
      else
        @patients = Patient.where("hmo_id = ? AND hospital_id IN (?) AND payment_status != ? AND date_admitted <= ?", hmo_id, hospital_ids, Patient::PAYMENT_STATUS[:fully_paid], date)
      end

    else
      @payment_method = params[:payment_method]

      unless doctor_id.blank?
        @patients = Patient.where("doctor_id = ? AND payment_method = ? AND hospital_id IN (?) AND payment_status != ? AND date_admitted <= ?", doctor_id, @payment_method, hospital_ids, Patient::PAYMENT_STATUS[:fully_paid], date)
      else
        @patients = Patient.where("payment_method = ? AND hospital_id IN (?) AND payment_status != ? AND date_admitted <= ?", @payment_method, hospital_ids, Patient::PAYMENT_STATUS[:fully_paid], date)
      end
    end
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
    @patient.state = "picture_uploaded"
    @patient.doctor_id = current_user.id
  end

  # Loads the form for editing details of an existing patient record.
  #   GET /patients/1/edit
  def edit
    @patient.state = "record_created"
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
        @patient.state = "picture_uploaded"
        @patient.doctor_id = current_user.id
        format.html { render :new }
        format.json { render json: @patient.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing patient record.
  #   PATCH/PUT /patients/1
  #   PATCH/PUT /patients/1.json
  def update
    @patient.payment_status = "CHECK WAITING"

    respond_to do |format|
      if @patient.update(patient_params)
        @patient.update_attribute(:balance, @patient.billing_amount - @patient.total_payments)

        format.html { redirect_to @patient, notice: 'Patient was updated' }
        format.json { render :show, status: :ok, location: @patient }
      else
        @patient.state = "record_created"
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

  def download_image
    @patient = Patient.find(params[:id])
    send_file(
      @patient.patient_picture.path,
      filename: "Patient_#{@patient.id}_picture"
    )
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
        :hmo_id,
        :contact_num,
        :hospital_id,
        :doctor_id,
        :billing_amount,
        :patient_picture,
        :surgeon,
        :remarks,
        :state,
        :payment_method,
        :procedure_date
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
