class HmosController < ApplicationController
	before_action :set_hmo, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active hmo records.
  #   GET /hmos
  #   GET /hmos.json
  def index
    @hmos = Hmo.all.paginate(page: params[:page], per_page: 10)
  end

  def hmo_patients_index
    @hospitals = current_user.is_role?("Doctor") ? Hospital.where(:id => Patient.where(:doctor_id => current_user).pluck(:hospital_id)).order(:name) : Hospital.order(:name)
    @hmos = Hmo
    hospital_ids = []
    date = Date.today

    if params[:search].present?
      hospital_ids = [params[:search][:hospital]] unless params[:search][:hospital].blank?
      date = params[:search][:date] unless params[:search][:date].blank?
    end

    if hospital_ids.empty?
      hospital_ids = current_user.is_role?("Doctor") ? [current_user.hospital_id] : Hospital.pluck(:id)
    end
    patients = Patient.where("hospital_id IN (?) AND balance >= ? AND date_admitted <= ?", hospital_ids, BigDecimal.new("0.0"), date)
    
    # HMO 
    hmo_ids = patients.pluck(:hmo_id)
    @hmos = Hmo.where(id: hmo_ids).order(:name)
    @hmo_total_balance= patients.where(payment_method: "HMO").sum(:balance)
    @hmos.paginate(page: params[:page], per_page: 1)

    #PHILHEALTH
    @philhealth_patients = patients.where(payment_method: "Philhealth")
    @philhealth_total_balance= @philhealth_patients.sum(:balance)
    @philhealth_patients.paginate(page: params[:page], per_page: 10)

    #PROMISSORY NOTE
    @promissory_note_patients = patients.where(payment_method: "Promissory Note")
    @promissory_note_total_balance= @promissory_note_patients.sum(:balance)
    @promissory_note_patients.paginate(page: params[:page], per_page: 10)
  end

  def all_transactions_index
  end

  def active_transactions_index
    @hospitals = current_user.is_role?("Doctor") ? Hospital.where(:id => Patient.where(:doctor_id => current_user).pluck(:hospital_id)).order(:name) : Hospital.order(:name)
    @hmos = Hmo
    @hospital_ids = []
    @date = Date.today
    @doctor_id = nil

    if params[:search].present?
      @hospital_ids = [params[:search][:hospital]] unless params[:search][:hospital].blank?
      @date = params[:search][:date] unless params[:search][:date].blank?
      @doctor_id = params[:search][:doctor] unless params[:search][:doctor].blank?
    end

    if @hospital_ids.empty?
      @hospital_ids = current_user.is_role?("Doctor") ? [current_user.hospital_id] : Hospital.pluck(:id)
    end
    
    if current_user.is_role?("Doctor")
      @doctor_id = current_user.id
    end

    @patients = Patient.where("hospital_id IN (?) AND payment_status != ? AND date_admitted <= ?", @hospital_ids, Patient::PAYMENT_STATUS[:fully_paid], @date)
    @patients = @patients.where(:doctor_id => @doctor_id) unless @doctor_id.nil?

    # HMO 
    hmo_ids = @patients.pluck(:hmo_id)
    @hmos = Hmo.where(id: hmo_ids).order(:name)
    @hmo_total_count = @patients.where(payment_method: Patient::PAYMENT_METHOD[:hmo]).uniq.count
    #@hmos.paginate(page: params[:page], per_page: 1)

    #PHILHEALTH
    @philhealth_patients = @patients.where(payment_method: Patient::PAYMENT_METHOD[:philhealth])
    @philhealth_total_count = @philhealth_patients.uniq.count
    #@philhealth_patients.paginate(page: params[:page], per_page: 10)

    #PROMISSORY NOTE
    @promissory_note_patients = @patients.where(payment_method: Patient::PAYMENT_METHOD[:promissory_note])
    @promissory_note_total_count = @promissory_note_patients.uniq.count
    #@promissory_note_patients.paginate(page: params[:page], per_page: 10)
  end

  def collectibles_index
    @hospitals = current_user.is_role?("Doctor") ? Hospital.where(:id => Patient.where(:doctor_id => current_user).pluck(:hospital_id)).order(:name) : Hospital.order(:name)
    @hmos = Hmo
    @hospital_ids = []
    @date = Date.today
    @doctor_id = nil

    if params[:search].present?
      @hospital_ids = [params[:search][:hospital]] unless params[:search][:hospital].blank?
      @date = params[:search][:date] unless params[:search][:date].blank?
      @doctor_id = params[:search][:doctor] unless params[:search][:doctor].blank?
    end

    if @hospital_ids.empty?
      @hospital_ids = current_user.is_role?("Doctor") ? [current_user.hospital_id] : Hospital.pluck(:id)
    end
    
    if current_user.is_role?("Doctor")
      @doctor_id = current_user.id
    end
    
    @patients = Patient.where("hospital_id IN (?) AND payment_status != ? AND date_admitted <= ?", @hospital_ids, Patient::PAYMENT_STATUS[:fully_paid], @date)
    @patients = @patients.where(:doctor_id => @doctor_id) unless @doctor_id.nil?

    # HMO 
    hmo_ids = @patients.pluck(:hmo_id)
    @hmos = Hmo.where(id: hmo_ids).order(:name)
    @hmo_total_amount = @patients.where(payment_method: Patient::PAYMENT_METHOD[:hmo]).sum(:balance)

    #PHILHEALTH
    @philhealth_patients = @patients.where(payment_method: Patient::PAYMENT_METHOD[:philhealth])
    @philhealth_total_amount = @philhealth_patients.sum(:balance)

    #PROMISSORY NOTE
    @promissory_note_patients = @patients.where(payment_method: Patient::PAYMENT_METHOD[:promissory_note])
    @promissory_note_total_amount = @promissory_note_patients.sum(:balance)
  end

  # Loads the details of a hmo record.
  #   GET /hmos/1
  #   GET /hmos/1.json
  def show
  end

  # Loads the form for creating a new hmo record.
  #   GET /hmos/new
  def new
    @hmo = Hmo.new
  end

  # Loads the form for editing details of an existing hmo record.
  #   GET /hmos/1/edit
  def edit
  end

  # Creates a new hmo record.
  #   POST /hmos
  #   POST /hmos.json
  def create
    @hmo = Hmo.new(hmo_params)

    respond_to do |format|
      if @hmo.save
        format.html { redirect_to @hmo, notice: 'HMO was successfully created.' }
        format.json { render :show, status: :created, location: @hmo }
      else
        format.html { render :new }
        format.json { render json: @hmo.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing hmo record.
  #   PATCH/PUT /hmos/1
  #   PATCH/PUT /hmos/1.json
  def update
    respond_to do |format|
      if @hmo.update(hmo_params)
        format.html { redirect_to @hmo, notice: 'HMO was updated' }
        format.json { render :show, status: :ok, location: @hmo }
      else
        format.html { render :edit }
        format.json { render json: @hmo.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes the record of a hmo.
  #   DELETE /hmos/1
  #   DELETE /hmos/1.json
  def destroy
    @hmo.destroy
    respond_to do |format|
      format.html { redirect_to hmos_url, notice: 'HMO was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hmo
      @hmo = Hmo.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hmo_params
      params.require(:hmo).permit(
        :name,
        :address,
        :contact_num,
        :contact_person
      )
    end
end
