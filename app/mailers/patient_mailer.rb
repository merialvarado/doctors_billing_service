class PatientMailer < ApplicationMailer
  default from: "info.anesbillingservice@gmail.com"
  # password: @n*7b&zwN4Nz!p3$

  def new_patient(user, patient, email)
    @patient_url = edit_patient_url(patient)
    @user = user
    mail(to: email, subject: '[Billing Service] New Patient for Encoding')
  end
end
