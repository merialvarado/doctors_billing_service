class Patient < ApplicationRecord

	belongs_to :hospital
	belongs_to :doctor, class_name: "User", foreign_key: "doctor_id"
	has_many :payments
	belongs_to :hmo

	validates :first_name, :surname, :patient_num, :date_admitted, :procedure, :contact_num, :hospital_id, :doctor_id, :hmo_id, presence: true
	validates :billing_amount, numericality: { greater_than: 0 }

	def full_name
		"#{first_name} #{middle_name} #{surname}"
	end

	def check_available!
		self.update_attribute(:payment_status, "CHECK AVAILABLE")
	end

	def is_check_waiting?
		self.payment_status.upcase == "CHECK WAITING" || self.payment_status.upcase == "CHECK WAITING FOR FULL PAYMENT" rescue false
	end

	def is_check_available?
		self.payment_status.upcase == "CHECK AVAILABLE" rescue false
	end

	def update_payment_status
		if !self.balance.zero? && !self.payments.empty?
			self.update_attribute(:payment_status, "CHECK WAITING FOR FULL PAYMENT") 
		elsif self.balance.zero?
			self.update_attribute(:payment_status, "FULLY PAID") 
		end
	end

	def self.get_total_billing_amount
		Patient.sum(:billing_amount)
	end

	def self.get_total_balance
		Patient.sum(:balance)
	end
end
