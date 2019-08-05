class PatientMailer < ApplicationMailer
  default from: "info.anesbillingservice@gmail.com"
  # password: @n*7b&zwN4Nz!p3$

  def new_patient(user, patient)
    @patient_url = edit_patient_url(patient)
    @user = user
    bcc_emails = []
    if Rails.env.development?
      bcc_emails << ENV['bcc_email_1'] 
      bcc_emails << ENV['bcc_email_2'] 
    end
    mail(to: @user.email, bcc: bcc_emails, subject: '[Billing Service] New Patient for Encoding')
  end
end
