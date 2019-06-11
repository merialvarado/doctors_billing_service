class HospitalsController < ApplicationController
	before_action :set_hospital, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index, :archive, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active hospital records.
  #   GET /hospitals
  #   GET /hospitals.json
  def index
    @hospitals = Hospital.all
  end

  # Loads the details of a hospital record.
  #   GET /hospitals/1
  #   GET /hospitals/1.json
  def show
  end

  # Loads the form for creating a new hospital record.
  #   GET /hospitals/new
  def new
    @hospital = Hospital.new
  end

  # Loads the form for editing details of an existing hospital record.
  #   GET /hospitals/1/edit
  def edit
  end

  # Creates a new hospital record.
  #   POST /hospitals
  #   POST /hospitals.json
  def create
    @hospital = Hospital.new(hospital_params)

    respond_to do |format|
      if @hospital.save
        format.html { redirect_to @hospital, notice: 'Hospital was successfully created.' }
        format.json { render :show, status: :created, location: @hospital }
      else
        format.html { render :new }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing hospital record.
  #   PATCH/PUT /hospitals/1
  #   PATCH/PUT /hospitals/1.json
  def update
    respond_to do |format|
      if @hospital.update(hospital_params)
        format.html { redirect_to @hospital, notice: 'Hospital was updated' }
        format.json { render :show, status: :ok, location: @hospital }
      else
        format.html { render :edit }
        format.json { render json: @hospital.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes the record of a hospital.
  #   DELETE /hospitals/1
  #   DELETE /hospitals/1.json
  def destroy
    if @hospital.has_schedule?
      respond_to do |format|
        format.html { redirect_to hospitals_url, notice: 'Failed to destroy hospital. Hospital has schedule.' }
        format.json { head :no_content }
      end
    else
      @hospital.destroy
      respond_to do |format|
        format.html { redirect_to hospitals_url, notice: 'Hospital was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hospital
      @hospital = Hospital.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hospital_params
      params.require(:hospital).permit(
        :name,
        :address,
        :contact_num
      )
    end
end
