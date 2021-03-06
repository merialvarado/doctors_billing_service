require 'csv'
class PatientUpload < ApplicationRecord
  mount_uploader :csv_file, CsvFileUploader

  belongs_to :uploaded_by, class_name: "User", foreign_key: :uploaded_by_id

  validates :csv_file, presence: true

  def process_csv
    PatientUpload.transaction do
      csv_text = File.read(self.csv_file.path)
      csv = CSV.parse(csv_text, :headers => true)

      row_counter = 0
      errors = []
      csv.each do |row|
        Rails.logger.info "ROW COUNTER: #{row_counter}"
        Rails.logger.info "ROW INFO: #{row}"

        row_counter += 1
        patient_info = {
          :doctor => row[0],
          :hospital => row[1],
          :date_admitted => row[2],
          :first_name => row[3].split(", ").last,
          :surname => row[3].split(", ").first,
          :payment_method => row[4],
          :surgeon => row[5],
          :procedure_type => row[6],
          :procedure_date => row[7],
          :billing_amount => row[8],
          :remarks => row[9]
        }

        # Process Doctor info
        doctor = User.where("LOWER(full_name) = ?", patient_info[:doctor].downcase).first
        if doctor.nil?
          errors << "ROW # #{row_counter}: Doctor is not yet registered to the system"
          return 400, errors
        else 
          patient_info[:doctor] = doctor
        end

        # Process Hospital info
        hospital = Hospital.where("LOWER(name) = ?", patient_info[:hospital].downcase).first
        hospital = Hospital.create(:name => patient_info[:hospital]) if hospital.nil?
        patient_info[:hospital] = hospital

        # Process payment method
        payment_method = ""
        if patient_info[:payment_method] == "Promissory Note"
          payment_method = "Promissory Note"
        elsif patient_info[:payment_method] == "Philhealth"
          payment_method = "Philhealth"
        else
          payment_method = "HMO"
          hmo = Hmo.where("LOWER(name) = ?", patient_info[:payment_method].downcase).first
          hmo = Hmo.create(:name => patient_info[:payment_method]) if hmo.nil?
          patient_info[:hmo] = hmo
        end
        patient_info[:payment_method] = payment_method

        # Process Procedure info
        procedure_type = ProcedureType.where("LOWER(name) = ? and doctor_id = ?", patient_info[:procedure_type].downcase, doctor.id).first
        procedure_type = ProcedureType.create(:name => patient_info[:procedure_type], :doctor_id=> doctor.id) if procedure_type.nil?
        patient_info[:procedure_type] = procedure_type

        # Process Surgeon info
        surgeon = Surgeon.where("LOWER(full_name) = ? and doctor_id = ?", patient_info[:surgeon].downcase, doctor.id).first
        surgeon = Surgeon.create(:full_name => patient_info[:surgeon], :doctor_id => doctor.id) if surgeon.nil?
        patient_info[:surgeon] = surgeon

        # Process billing amount
        patient_info[:billing_amount] = BigDecimal.new("0") if patient_info[:billing_amount].blank?

        # Add balance
        patient_info[:balance] = patient_info[:billing_amount]
        # Add state
        patient_info[:state] = "record_created"
        # Add payment status
        patient_info[:payment_status] = "CHECK WAITING"

        patient = Patient.new(patient_info)

        unless patient.save
          errors << "ROW # #{row_counter}: #{patient.errors.first}"
          return 400, errors
        end
      end
      return 200
    end
  end
end
