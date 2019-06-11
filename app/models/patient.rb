class Patient < ApplicationRecord

	belongs_to :hospital
	belongs_to :doctor, class_name: "User", foreign_key: "doctor_id"

	validates :first_name, :surname, :patient_num, :date_admitted, :procedure, :contact_num, :hospital_id, :doctor_id, presence: true

	def full_name
		"#{first_name} #{middle_name} #{surname}"
	end
end
