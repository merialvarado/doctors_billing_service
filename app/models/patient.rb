class Patient < ApplicationRecord
	mount_uploader :patient_picture, PatientPictureUploader

	belongs_to :hospital, optional: true
	belongs_to :doctor, class_name: "User", foreign_key: "doctor_id"
	has_many :payments
	belongs_to :hmo, optional: true

	validates :patient_picture, :procedure, :surgeon, :remarks, :doctor_id, presence: true, if: lambda{|o| o.state == "picture_uploaded" }
	validates :first_name, :surname, :date_admitted, :hospital_id, :payment_method, presence: true, if: lambda{|o| o.state == "record_created" }
	validates :hmo_id, presence: true, if: lambda{|o| o.payment_method == "HMO"}
	validates :billing_amount, numericality: { greater_than_or_equal_to: 0 }
	#validates :patient_num, :contact_num, presence: true, if: lambda{|o| o.state == "record_created" }

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

	def total_payments
		self.payments.sum(:amount)
	end

	def payment_method_with_details
		payment = ""
		if self.payment_method == "HMO"
			payment = "#{self.payment_method} - #{self.hmo.name rescue ''}"
		else
			payment = self.payment_method
		end
		return payment
	end

	def self.get_total_billing_amount
		Patient.sum(:billing_amount)
	end

	def self.get_total_balance
		Patient.sum(:balance)
	end

	def self.hmo_total_amount(current_user)
		unless current_user.is_role?"Doctor"
			Patient.where(payment_method: "HMO").sum(:billing_amount)
		else
			Patient.where(payment_method: "HMO", doctor_id: current_user.id).sum(:billing_amount)
		end
	end

	def self.philhealth_total_amount(current_user)
		unless current_user.is_role?"Doctor"
			Patient.where(payment_method: "Philhealth").sum(:billing_amount)
		else
			Patient.where(payment_method: "Philhealth", doctor_id: current_user.id).sum(:billing_amount)
		end
	end

	def self.promissory_note_total_amount(current_user)
		unless current_user.is_role?"Doctor"
			Patient.where(payment_method: "Promissory Note").sum(:billing_amount)
		else
			Patient.where(payment_method: "Promissory Note", doctor_id: current_user.id).sum(:billing_amount)
		end
	end
end
