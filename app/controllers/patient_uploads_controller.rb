class PatientUploadsController < ApplicationController
  before_action :set_patient_upload, only: [:show, :edit, :update, :destroy, :process_csv]
  load_and_authorize_resource only: [:index, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active patient_upload records.
  #   GET /patient_uploads
  #   GET /patient_uploads.json
  def index
    @patient_uploads = PatientUpload.all.paginate(page: params[:page], per_page: 10)
  end

  # Loads the details of a patient_upload record.
  #   GET /patient_uploads/1
  #   GET /patient_uploads/1.json
  def show
  end

  # Loads the form for creating a new patient_upload record.
  #   GET /patient_uploads/new
  def new
    @patient_upload = PatientUpload.new
    @patient_upload.state = "file_uploaded"
    @patient_upload.uploaded_by_id = current_user.id
  end

  # Loads the form for editing details of an existing patient_upload record.
  #   GET /patient_uploads/1/edit
  def edit
  end

  # Creates a new patient_upload record.
  #   POST /patient_uploads
  #   POST /patient_uploads.json
  def create
    @patient_upload = PatientUpload.new(patient_upload_params)

    respond_to do |format|
      if @patient_upload.save
        format.html { redirect_to @patient_upload, notice: 'Patient Upload was successfully created.' }
        format.json { render :show, status: :created, location: @patient_upload }
      else
        @patient_upload.state = "file_uploaded"
        @patient_upload.uploaded_by_id = current_user.id
        format.html { render :new }
        format.json { render json: @patient_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing patient_upload record.
  #   PATCH/PUT /patient_uploads/1
  #   PATCH/PUT /patient_uploads/1.json
  def update
    respond_to do |format|
      if @patient_upload.update(patient_upload_params)
        format.html { redirect_to @patient_upload, notice: 'Patient Upload was updated' }
        format.json { render :show, status: :ok, location: @patient_upload }
      else
        format.html { render :edit }
        format.json { render json: @patient_upload.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes the record of a patient_upload.
  #   DELETE /patient_uploads/1
  #   DELETE /patient_uploads/1.json
  def destroy
    @patient_upload.destroy
    respond_to do |format|
      format.html { redirect_to patient_uploads_url, notice: 'Patient Upload was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def process_csv
    status, errors = @patient_upload.process_csv

    Rails.logger.info "PROCESS CSV STATUS: #{status}"

    if status == 200
      @patient_upload.update_attribute(:state, "processed")
      respond_to do |format|
        format.html { redirect_to patient_uploads_url, notice: 'Patient Upload was successfully processed.' }
        format.json { head :no_content }
      end
    else
      respond_to do |format|
        format.html { redirect_to patient_uploads_url, alert: 'There are problems processing the CSV file. ' + errors.join(" ") }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_patient_upload
      @patient_upload = PatientUpload.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def patient_upload_params
      params.require(:patient_upload).permit(
        :csv_file,
        :uploaded_by_id,
        :state
      )
    end
end
