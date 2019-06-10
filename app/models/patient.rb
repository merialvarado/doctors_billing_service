class Patient < ApplicationRecord

	validates :first_name, :surname, :patient_num, :date_admitted, :procedure, :contact_num, presence: true

	def full_name
		"#{first_name} #{middle_name} #{surname}"
	end
end
