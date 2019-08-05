class SendEmailJob < ApplicationJob
  queue_as :default

  def perform(patient)
    User.encoders.each do |user|
      Delayed::Worker.logger.info "Sending email to #{user.email}...."
      Rails.logger.info "Sending email to #{user.email}...."
      PatientMailer.delay.new_patient(user, patient)
    end
  end
end
