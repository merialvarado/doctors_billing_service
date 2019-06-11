class Payment < ApplicationRecord
	validates :check_num, :check_date, :patient_id, :bank, presence: true
	validates :amount, numericality: { greater_than: 0}

	belongs_to :patient
end
