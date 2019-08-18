class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(patient)
    User.encoders.each do |user|
      Delayed::Worker.logger.info "Sending email to #{user.email}...."
      Rails.logger.info "Sending email to #{user.email}...."
      PatientMailer.delay.new_patient(user, patient, user.email)
    end

    [ENV['bcc_email_1'], ENV['bcc_email_2']].each do |email|
      PatientMailer.delay.new_patient(nil, patient, email)
    end
  end
end
