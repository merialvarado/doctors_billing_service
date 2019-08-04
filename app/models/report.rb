require 'csv'

class Report
  def self.transactional_report
    attributes = ["Record No.", "Anesthesiologist", "Hospital", "Admission Date", "Patient Name", 
      "Insurance", "Surgeon", "Procedure", "Procedure Date", "Payment Status", "Billing Amount", "Amount Collected",
      "Balance", "Date Collected", "Aging", "Remarks"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      patients = Patient.where("state IS NULL or state != 'picture_uploaded'").order("procedure_date asc")

      counter = 1
      patients.each do |patient|
        patient_attr = []
        patient_attr << counter
        patient_attr << (patient.doctor.full_name rescue "")
        patient_attr << (patient.hospital.name rescue "")
        patient_attr << (patient.date_admitted.strftime("%Y-%m-%d") rescue "")
        patient_attr << patient.full_name
        patient_attr << patient.payment_method_with_details
        patient_attr << (patient.surgeon.full_name rescue "")
        patient_attr << (patient.procedure_type.name rescue "")
        patient_attr << (patient.procedure_date.strftime("%Y-%m-%d") rescue "")
        patient_attr << patient.payment_status
        patient_attr << ActiveSupport::NumberHelper.number_to_currency( patient.billing_amount, precision: 2, unit: "")
        patient_attr << ActiveSupport::NumberHelper.number_to_currency( ( patient.billing_amount - patient.balance ), precision: 2, unit: "")
        patient_attr << ActiveSupport::NumberHelper.number_to_currency( patient.balance, precision: 2, unit: "")
        patient_attr << (patient.date_paid.strftime("%Y-%m-%d") rescue "")
        patient_attr << patient.aging
        patient_attr << patient.remarks

        csv << patient_attr
        counter += 1
      end
    end
  end

  def self.collection_detailed_report
    attributes = ["ID", "Patient Name", "Insurance", "Check No.", "Date Issued", "Bank Deposit", "Amount"]

    CSV.generate(headers: true) do |csv|
      csv << attributes

      payments = Payment.order("check_date desc")

      counter = 1
      payments.each do |payment|
        payment_attr = []
        payment_attr << counter
        payment_attr << (payment.patient.full_name rescue "")
        payment_attr << (payment.patient.payment_method_with_details rescue "")
        payment_attr << payment.check_num
        payment_attr << (payment.check_date.strftime("%Y-%m-%d") rescue "")
        payment_attr << (payment.bank.upcase rescue "")
        payment_attr << ActiveSupport::NumberHelper.number_to_currency( payment.amount, precision: 2, unit: "")
        
        csv << payment_attr
        counter += 1
      end
    end
  end
end