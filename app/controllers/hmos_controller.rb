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

    hmo_ids = Patient.where("hospital_id IN (?) AND balance >= ? AND date_admitted <= ?", hospital_ids, BigDecimal.new("0.0"), date).pluck(:hmo_id)
    @hmos = Hmo.where(id: hmo_ids).order(:name)

    @hmos.paginate(page: params[:page], per_page: 10)
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
