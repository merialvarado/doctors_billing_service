class ProcedureTypesController < ApplicationController
before_action :set_procedure_type, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource only: [:index, :archive, :show, :new, :create, :edit, :update, :destroy]

  # Loads a list of all active procedure_type records.
  #   GET /procedure_types
  #   GET /procedure_types.json
  def index
    if current_user.is_role? "Doctor"
      @procedure_types = ProcedureType.where(doctor_id: current_user.id).order(:name).paginate(page: params[:page], per_page: 10)
    else
      @procedure_types = ProcedureType.order(:name).paginate(page: params[:page], per_page: 10)
    end
  end

  # Loads the details of a procedure_type record.
  #   GET /procedure_types/1
  #   GET /procedure_types/1.json
  def show
  end

  # Loads the form for creating a new procedure_type record.
  #   GET /procedure_types/new
  def new
    @procedure_type = ProcedureType.new
  end

  # Loads the form for editing details of an existing procedure_type record.
  #   GET /procedure_types/1/edit
  def edit
  end

  # Creates a new procedure_type record.
  #   POST /procedure_types
  #   POST /procedure_types.json
  def create
    @procedure_type = ProcedureType.new(procedure_type_params)

    respond_to do |format|
      if @procedure_type.save
        format.html { redirect_to procedure_type_path(@procedure_type, active_tab: TAB_NAMES[:system_settings]), notice: 'Procedure Type was successfully created.' }
        format.json { render json: @procedure_type.to_json, status: :created, location: @procedure_type }
      else
        puts @procedure_type.errors.first
        format.html { render :new }
        format.json { render json: @procedure_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # Updates the details of an existing procedure_type record.
  #   PATCH/PUT /procedure_types/1
  #   PATCH/PUT /procedure_types/1.json
  def update
    respond_to do |format|
      if @procedure_type.update(procedure_type_params)
        format.html { redirect_to procedure_type_path(@procedure_type, active_tab: TAB_NAMES[:system_settings]), notice: 'Procedure Type was updated' }
        format.json { render :show, status: :ok, location: @procedure_type }
      else
        format.html { render :edit }
        format.json { render json: @procedure_type.errors, status: :unprocessable_entity }
      end
    end
  end

  # Deletes the record of a procedure_type.
  #   DELETE /procedure_types/1
  #   DELETE /procedure_types/1.json
  def destroy
    if @procedure_type.has_schedule?
      respond_to do |format|
        format.html { redirect_to procedure_types_url, notice: 'Failed to destroy procedure type.' }
        format.json { head :no_content }
      end
    else
      @procedure_type.destroy
      respond_to do |format|
        format.html { redirect_to procedure_types_url, notice: 'Procedure Type was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_procedure_type
      @procedure_type = ProcedureType.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def procedure_type_params
      params.require(:procedure_type).permit(
        :name,
        :doctor_id
      )
    end
end

